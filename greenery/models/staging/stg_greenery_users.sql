{{
  config(
    materialized='table'
  )
}}

select
user_id as id,
first_name,
last_name,
email,
phone_number,
address,
zipcode,
state,
country,
created_at,
updated_at
from {{ source('greenery', 'users') }} users
left join {{ ref('stg_greenery_addresses') }} addresses on addresses.id = users.address_id
