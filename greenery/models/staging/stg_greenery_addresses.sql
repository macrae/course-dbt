{{
  config(
    materialized='table'
  )
}}

select
address_id as id,
address,
zipcode,
state,
country
from {{ source('greenery', 'addresses') }}