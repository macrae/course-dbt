{{
  config(
    materialized='table'
  )
}}

select
promo_id as id,
discount,
status
from {{ source('greenery', 'promos') }}