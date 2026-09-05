select 
    order_id::number as order_id, 
    try_to_timestamp(order_timestamp) as order_timestamp, 
    try_to_date(order_date) as order_date, 
    try_to_number(user_id) as customer_id, 
    try_to_number(r_id) as restaurant_id,
    trim(coalesce(regexp_substr(restaurant_city, '[^,]+$'), restaurant_city)) as city,
    cuisine, 
    try_to_number(items_count) as items_count, 
    try_to_number(sales_qty) as sales_qty, 
    try_to_decimal(subtotal, 10, 2) as subtotal, 
    try_to_decimal(discount, 10, 2) as discount, 
    try_to_decimal(delivery_fee, 10, 2) as delivery_fee, 
    try_to_decimal(gst, 10, 2) as gst, 
    try_to_decimal(sales_amount, 10, 2) as sales_amount,
    currency, 
    payment_method, 
    order_status, 
    (order_status = 'Delivered') as is_delivered,
    try_to_decimal(customer_rating, 3, 1) as customer_rating, 
    try_to_number(delivery_time_min) as delivery_time_min
from {{ source('raw', 'orders') }}
where try_to_number(order_id) is not null