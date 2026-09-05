-- ============================================================================
-- 05_copy_into.sql: Bronze Ingestion via COPY INTO
-- ============================================================================
USE ROLE ZOMATO_ROLE;
USE WAREHOUSE ZOMATO_WH;
USE DATABASE ZOMATO;
USE SCHEMA RAW;

-- 1. Ingest Orders
COPY INTO orders
FROM @ZOMATO_STAGE/orders/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- 2. Ingest Order Items
COPY INTO order_items
FROM @ZOMATO_STAGE/order_items/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- 3. Ingest Restaurants
COPY INTO restaurants
FROM @ZOMATO_STAGE/restaurant/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- 4. Ingest Users
COPY INTO users
FROM @ZOMATO_STAGE/users/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- 5. Ingest Food
COPY INTO food
FROM @ZOMATO_STAGE/food/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- 6. Ingest Menu
COPY INTO menu
FROM @ZOMATO_STAGE/menu/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- 7. Ingest Reviews
COPY INTO reviews
FROM @ZOMATO_STAGE/reviews/
FILE_FORMAT = (FORMAT_NAME = CSV_FORMAT)
ON_ERROR = 'SKIP_FILE';

-- Verification Queries
SELECT 'orders' as table_name, count(*) as row_count FROM orders
UNION ALL
SELECT 'order_items', count(*) FROM order_items
UNION ALL
SELECT 'restaurants', count(*) FROM restaurants
UNION ALL
SELECT 'users', count(*) FROM users
UNION ALL
SELECT 'food', count(*) FROM food
UNION ALL
SELECT 'menu', count(*) FROM menu
UNION ALL
SELECT 'reviews', count(*) FROM reviews;