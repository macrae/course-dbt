-- add order time series measurements
select * from {{ ref('stg_greenery_orders') }} orders