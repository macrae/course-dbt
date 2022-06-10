{{
  config(
    materialized='table'
  )
}}

select
event_id as id,
session_id,
user_id,
page_url,
created_at,
event_type,
order_id,
product_id
from {{ source('greenery', 'events') }}