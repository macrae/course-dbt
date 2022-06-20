-- TODO: add recency, frequency, and monetary (RFM) value product dimensions
select * from {{ ref('stg_greenery_products') }} products