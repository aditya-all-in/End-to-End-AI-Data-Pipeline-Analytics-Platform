-- ============================================================================
-- 04_raw_tables.sql: Bronze (RAW) Table DDLs
-- ============================================================================
USE ROLE ZOMATO_ROLE;
USE WAREHOUSE ZOMATO_WH;
USE DATABASE ZOMATO;
USE SCHEMA RAW;

-- 1. Orders (High Volume Fact Source)
CREATE OR REPLACE TABLE orders (
    order_id VARCHAR,
    order_timestamp VARCHAR,
    order_date VARCHAR,
    user_id VARCHAR,
    r_id VARCHAR,
    restaurant_city VARCHAR,
    cuisine VARCHAR,
    items_count VARCHAR,
    sales_qty VARCHAR,
    subtotal VARCHAR,
    discount VARCHAR,
    delivery_fee VARCHAR,
    gst VARCHAR,
    sales_amount VARCHAR,
    currency VARCHAR,
    payment_method VARCHAR,
    order_status VARCHAR,
    customer_rating VARCHAR,
    delivery_time_min VARCHAR
);

-- 2. Order Items (Line Items Source)
CREATE OR REPLACE TABLE order_items (
    order_item_id VARCHAR,
    order_id VARCHAR,
    r_id VARCHAR,
    f_id VARCHAR,
    price VARCHAR,
    quantity VARCHAR,
    line_amount VARCHAR
);

-- 3. Restaurants Dimension Source
CREATE OR REPLACE TABLE restaurants (
    idx VARCHAR,
    id VARCHAR,
    name VARCHAR,
    city VARCHAR,
    rating VARCHAR,
    rating_count VARCHAR,
    cost VARCHAR,
    cuisine VARCHAR,
    lic_no VARCHAR,
    link VARCHAR,
    address VARCHAR,
    menu VARCHAR
);

-- 4. Users / Customers Source
CREATE OR REPLACE TABLE users (
    idx VARCHAR,
    user_id VARCHAR,
    name VARCHAR,
    email VARCHAR,
    password VARCHAR,
    age VARCHAR,
    gender VARCHAR,
    marital_status VARCHAR,
    occupation VARCHAR,
    monthly_income VARCHAR,
    education VARCHAR,
    family_size VARCHAR
);

-- 5. Food Dimension Source
CREATE OR REPLACE TABLE food (
    idx VARCHAR,
    f_id VARCHAR,
    item VARCHAR,
    veg_or_non_veg VARCHAR
);

-- 6. Menu Dimension Source
CREATE OR REPLACE TABLE menu (
    idx VARCHAR,
    menu_id VARCHAR,
    r_id VARCHAR,
    f_id VARCHAR,
    cuisine VARCHAR,
    price VARCHAR
);

-- 7. Reviews Source (Unstructured / Sentiment Text)
CREATE OR REPLACE TABLE reviews (
    review_id VARCHAR,
    order_id VARCHAR,
    user_id VARCHAR,
    restaurant_id VARCHAR,
    rating VARCHAR,
    comment VARCHAR,
    review_date VARCHAR
);