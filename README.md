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

### Week 2 Assignment

- What is our user repeat rate?
```
select 
count(distinct user_id) 
from "dbt_sean_m"."int_greenery_user_orders"
where n_orders > 2
```
`count = 99`

- What are good indicators of a user who will likely purchase again? What about indicators of users 
who are likely NOT to purchase again? If you had more data, what features would you want to look 
into to answer this question?

Hypothesis - the average order basket size (# of items), is correlated with repeat buyer behavior.

```
with avg_order_size as (
  select 
  user_id,
  case when n_orders < 2 then False else True end as repeat_buyer,
  n_items / n_orders as avg_order_size 
  from "dbt_sean_m"."int_greenery_user_orders"
  order by 2 desc
  )
  
  select 
  repeat_buyer,
  avg(avg_order_size) as avg_order_size 
  from avg_order_size
  group by 1 order by 1
```

```
repeat_buyer    avg_order_size
false           2.320
true            2.339
```

Results - The average order size is almost the same (2.320 items/order) between repeat and one-time
buyers.