{{
  config(
    materialized='view'
  )
}}

with order_items_summary as (
    select
    order_id,
    sum(price) as total_price,
    avg(price) as avg_price_per_item,
    count(product_id) as n_items,
    sum(case when name = 'Monstera' then 1 else 0 end) as n_monstera,
    sum(case when name = 'Peace Lily' then 1 else 0 end) as n_peace_lily,
    sum(case when name = 'Alocasia Polly' then 1 else 0 end) as n_alocasia_polly,
    sum(case when name = 'Money Tree' then 1 else 0 end) as n_money_tree,
    sum(case when name = 'Jade Plant' then 1 else 0 end) as n_jade_plant,
    sum(case when name = 'Calathea Makoyana' then 1 else 0 end) as n_calathea_makoyana,
    sum(case when name = 'String of pearls' then 1 else 0 end) as n_string_of_pearls,
    sum(case when name = 'Aloe Vera' then 1 else 0 end) as n_aloe_vera,
    sum(case when name = 'Birds Nest Fern' then 1 else 0 end) as n_birds_nest_fern,
    sum(case when name = 'ZZ Plant' then 1 else 0 end) as n_zz_plant,
    sum(case when name = 'Ponytail Palm' then 1 else 0 end) as n_ponytail_palm,
    sum(case when name = 'Spider Plant' then 1 else 0 end) as n_spider_plant,
    sum(case when name = 'Ficus' then 1 else 0 end) as n_ficus,
    sum(case when name = 'Orchid' then 1 else 0 end) as n_orchid,
    sum(case when name = 'Fiddle Leaf Fig' then 1 else 0 end) as n_fiddle_leaf_fig,
    sum(case when name = 'Rubber Plant' then 1 else 0 end) as n_rubber_plant,
    sum(case when name = 'Devil''s Ivy' then 1 else 0 end) as n_devils_ivy,
    sum(case when name = 'Bamboo' then 1 else 0 end) as n_bamboo,
    sum(case when name = 'Dragon Tree' then 1 else 0 end) as n_dragon_tree,
    sum(case when name = 'Bird of Paradise' then 1 else 0 end) as n_bird_of_paradise,
    sum(case when name = 'Boston Fern' then 1 else 0 end) as n_boston_fern,
    sum(case when name = 'Pink Anthurium' then 1 else 0 end) as n_pink_anthurium,
    sum(case when name = 'Majesty Palm' then 1 else 0 end) as n_majesty_palm,
    sum(case when name = 'Pilea Peperomioides' then 1 else 0 end) as n_pilea_peperomioides,
    sum(case when name = 'Pothos' then 1 else 0 end) as n_pothos,
    sum(case when name = 'Arrow Head' then 1 else 0 end) as n_arrow_head,
    sum(case when name = 'Cactus' then 1 else 0 end) as n_cactus,
    sum(case when name = 'Snake Plant' then 1 else 0 end) as n_snake_plant,
    sum(case when name = 'Angel Wings Begonia' then 1 else 0 end) as n_angel_wings_begonia
    from
    {{ ref('stg_greenery_order_items') }} order_items
    left join {{ ref('stg_greenery_products') }} products on products.id = order_items.product_id
    group by 1
)

select
users.id as user_id,
count(distinct order_id) as n_orders,
sum(total_price) as total_revenue,
sum(n_items) as n_items,
sum(n_monstera) as n_monstera,
sum(n_peace_lily) as n_peace_lily,
sum(n_alocasia_polly) as n_alocasia_polly,
sum(n_money_tree) as n_money_tree,
sum(n_jade_plant) as n_jade_plant,
sum(n_calathea_makoyana) as n_calathea_makoyana,
sum(n_string_of_pearls) as n_string_of_pearls,
sum(n_aloe_vera) as n_aloe_vera,
sum(n_birds_nest_fern) as n_birds_nest_fern,
sum(n_zz_plant) as n_zz_plant,
sum(n_ponytail_palm) as n_ponytail_palm,
sum(n_spider_plant) as n_spider_plant,
sum(n_ficus) as n_ficus,
sum(n_orchid) as n_orchid,
sum(n_fiddle_leaf_fig) as n_fiddle_leaf_fig,
sum(n_rubber_plant) as n_rubber_plant,
sum(n_devils_ivy) as n_devils_ivy,
sum(n_bamboo) as n_bamboo,
sum(n_dragon_tree) as n_dragon_tree,
sum(n_bird_of_paradise) as n_bird_of_paradise,
sum(n_boston_fern) as n_boston_fern,
sum(n_pink_anthurium) as n_pink_anthurium,
sum(n_majesty_palm) as n_majesty_palm,
sum(n_pilea_peperomioides) as n_pilea_peperomioides,
sum(n_pothos) as n_pothos,
sum(n_arrow_head) as n_arrow_head,
sum(n_cactus) as n_cactus,
sum(n_snake_plant) as n_snake_plant,
sum(n_angel_wings_begonia) as n_angel_wings_begonia
from {{ ref('stg_greenery_users') }} users
left join {{ ref('stg_greenery_orders') }} orders on orders.user_id = users.id
left join order_items_summary on order_items_summary.order_id = orders.id
group by 1
