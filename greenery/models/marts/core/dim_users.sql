{{
  config(
    materialized='view'
  )
}}

select
id as user_id,
zipcode,
state,
(CURRENT_DATE::date - created_at::date) AS days_since_registration  -- recency
from {{ ref('stg_greenery_users') }}

-- TODO: add frequency and monetary value dimensions to `dim_users`