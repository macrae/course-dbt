-- add page view aggregate statistics (maybe add some graph features, like neighbor edges)

select * from {{ ref('stg_greenery_events') }} events