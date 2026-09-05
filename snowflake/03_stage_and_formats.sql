-- ============================================================================
-- 03_stage_and_formats.sql: File Formats and External Stages
-- ============================================================================
USE ROLE ZOMATO_ROLE;
USE WAREHOUSE ZOMATO_WH;
USE DATABASE ZOMATO;
USE SCHEMA RAW;

-- 1. Standard CSV File Format for Ingestion
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL', 'null', '', 'None')
    EMPTY_FIELD_AS_NULL = TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
    TRIM_SPACE = TRUE;

-- 2. External Stage referencing S3 via Storage Integration
CREATE OR REPLACE STAGE ZOMATO_STAGE
    STORAGE_INTEGRATION = s3_zomato_integration
    URL = 's3://<YOUR_S3_BUCKET_NAME>/raw/'
    FILE_FORMAT = CSV_FORMAT;

-- Verification: List files staged in S3
-- LIST @ZOMATO_STAGE;