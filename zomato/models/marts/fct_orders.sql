{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge',
    on_schema_change='sync_all_columns'
) }}

with orders as (
    select * from {{ ref('stg_orders') }}
    {% if is_incremental() %}
        -- Lookback window of 3 days captures late-arriving records and status updates
        where order_timestamp >= (select dateadd(day, -3, max(order_timestamp)) from {{ this }})
    {% endif %}
),
order_metrics as (
    select 
        order_id,
        count(distinct order_item_id) as total_items_count,
        sum(quantity) as total_quantity
    from {{ ref('stg_order_items') }}
    group by 1
)
select 
    o.order_id,
    o.order_timestamp,
    o.order_date,
    o.customer_id,
    o.restaurant_id,
    o.city,
    o.cuisine,
    coalesce(m.total_items_count, o.items_count) as items_count,
    coalesce(m.total_quantity, o.sales_qty) as sales_qty,
    o.subtotal,
    o.discount,
    o.delivery_fee,
    o.gst,
    o.sales_amount,
    o.currency,
    o.payment_method,
    o.order_status,
    o.is_delivered,
    o.customer_rating,
    o.delivery_time_min
from orders o
left join order_metrics m on o.order_id = m.order_id