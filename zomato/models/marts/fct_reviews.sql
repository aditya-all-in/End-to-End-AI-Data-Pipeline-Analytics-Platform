{{ config(materialized='table') }}

select
    r.review_id,
    r.order_id,
    r.customer_id,
    r.restaurant_id,
    res.restaurant_name,
    res.city as restaurant_city,
    res.cuisine,
    r.rating,
    r.comment,
    r.review_date
from {{ ref('stg_reviews') }} r
left join {{ ref('dim_restaurants') }} res 
    on r.restaurant_id = res.restaurant_id