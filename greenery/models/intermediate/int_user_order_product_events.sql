{{
  config(
    materialized='view'
  )
}}

with user_order_products as (
    select distinct
    users.id as user_id,
    orders.id as order_id,
    order_items.product_id as product_id
    from {{ ref('stg_greenery_users') }} users
    left join {{ ref('stg_greenery_orders') }} orders on users.id = orders.user_id
    left join {{ ref('stg_greenery_order_items') }} order_items on orders.id = order_items.order_id
),

order_events as (
  select
  uop.user_id,
  uop.order_id,
  uop.product_id,
  sum(case when event_type = 'checkout' then 1 else 0 end) as checkout,
  sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped
  from user_order_products uop
  left join {{ ref('stg_greenery_events') }} events on uop.order_id = events.order_id
  group by 1, 2, 3
),

product_events as (
  select
  uop.user_id,
  uop.order_id,
  uop.product_id,
  sum(case when events.event_type = 'page_view' then 1 else 0 end) as page_view,
  sum(case when events.event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart
  from user_order_products uop
  left join {{ ref('stg_greenery_events') }} events on uop.product_id = events.product_id
  group by 1, 2, 3
)

select
  coalesce(o.user_id, p.user_id) as user_id,
  coalesce(o.order_id, p.order_id) as order_id,
  coalesce(o.product_id, p.product_id) as product_id,
  page_view,
  add_to_cart,
  checkout,
  package_shipped
from order_events o
join product_events p on o.user_id = p.user_id and o.order_id = p.order_id and o.product_id = p.product_id