-- ============================================================================
-- 02_storage_integration.sql: Keyless S3 Cloud Storage Integration
-- ============================================================================
USE ROLE ACCOUNTADMIN;

-- Keyless integration via AWS IAM Trust Policy and External ID
CREATE OR REPLACE STORAGE INTEGRATION s3_zomato_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<YOUR_AWS_ACCOUNT_ID>:role/zomato-snowflake-access-role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://<YOUR_S3_BUCKET_NAME>/raw/');

GRANT USAGE ON INTEGRATION s3_zomato_integration TO ROLE ZOMATO_ROLE;

-- Run this to retrieve STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID
-- to update your AWS IAM Role trust relationship:
DESC INTEGRATION s3_zomato_integration;