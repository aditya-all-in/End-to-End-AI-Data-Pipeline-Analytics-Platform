select
    review_id::number as review_id,
    try_to_number(order_id) as order_id,
    try_to_number(user_id) as customer_id,
    try_to_number(restaurant_id) as restaurant_id,
    try_to_number(rating) as rating,
    comment::string as comment,
    try_to_date(review_date) as review_date
from {{ source('raw', 'reviews') }}
where try_to_number(review_id) is not null
  and comment is not null