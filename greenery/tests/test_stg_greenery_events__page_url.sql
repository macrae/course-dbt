-- TODO: add test asserting that page urls are valid

select * from {{ ref('stg_greenery_events') }}