{{
  config(
    materialized='table'
  )
}}

select
product_id as id,
name,
price,
inventory
from {{ source('greenery', 'products') }}