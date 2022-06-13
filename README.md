### Week 1 Assignment

- How many users do we have?
```
select count(distinct id) from dbt_sean_m.stg_greenery_users
```
`count = 130`

- On average, how many orders do we receive per hour?
```
with 
  orders_by_hour as (
    select
    date_trunc('hour', created_at),
    count(distinct id) as n_orders
    from dbt_sean_m.stg_greenery_orders
    group by 1
  )
  
  select avg(n_orders) from orders_by_hour
```
`avg = 7.5208333333333333`

- On average, how long does an order take from being placed to being delivered?
```
with
  delivery_window as (
    select
    extract(epoch from estimated_delivery_at::timestamp - created_at::timestamp) / 60 / 60 as hours_to_deliver
    from dbt_sean_m.stg_greenery_orders
    where estimated_delivery_at is not null
  )
  
select avg(hours_to_deliver) from delivery_window
```
`avg = 70.39490445859873`

- How many users have only made one purchase? Two purchases? Three+ purchases?
 _Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase._
 ```
 with
  order_summary as (
    select
    user_id,
    count(distinct id) as n_orders
    from dbt_sean_m.stg_greenery_orders
    group by 1
  )
  
  select avg(n_orders) from order_summary
```
`avg = 2.9112903225806452`

- On average, how many unique sessions do we have per hour?
```
with
  session_summary as (
    select
    date_trunc('hour', created_at) as created_at_hour,
    count(distinct session_id) as n_sessions
    from dbt_sean_m.stg_greenery_events
    group by 1
  )

select avg(n_sessions) from session_summary
```
`avg = 16.3275862068965517`