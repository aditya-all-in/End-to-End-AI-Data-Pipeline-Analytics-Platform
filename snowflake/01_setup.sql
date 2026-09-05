-- ============================================================================
-- 01_setup.sql: Database, Warehouse, Roles, and Schemas
-- ============================================================================

-- 1. Create Role and Grant to Current User
USE ROLE ACCOUNTADMIN;

CREATE ROLE IF NOT EXISTS ZOMATO_ROLE;
GRANT ROLE ZOMATO_ROLE TO USER CURRENT_USER();

-- 2. Create Virtual Warehouse (FinOps Optimized)
-- Sized X-SMALL with 60s auto-suspend to prevent idle credit consumption
CREATE WAREHOUSE IF NOT EXISTS ZOMATO_WH
    WITH 
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Dedicated warehouse for Zomato ELT workloads';

GRANT USAGE, OPERATE ON WAREHOUSE ZOMATO_WH TO ROLE ZOMATO_ROLE;

-- 3. Create Database & Medallion Schemas
CREATE DATABASE IF NOT EXISTS ZOMATO;
GRANT ALL ON DATABASE ZOMATO TO ROLE ZOMATO_ROLE;

USE DATABASE ZOMATO;

CREATE SCHEMA IF NOT EXISTS ZOMATO.RAW
    COMMENT = 'Bronze Layer: Raw ingested data from external stages';

CREATE SCHEMA IF NOT EXISTS ZOMATO.STAGING
    COMMENT = 'Silver Layer: Cleaned, casted, 1:1 view transformations';

CREATE SCHEMA IF NOT EXISTS ZOMATO.MARTS
    COMMENT = 'Gold Layer: Kimball Star Schema dimensional models and incremental facts';

CREATE SCHEMA IF NOT EXISTS ZOMATO.SNAPSHOT
    COMMENT = 'SCD Type 2 snapshots for dimensional change tracking';

GRANT ALL ON SCHEMA ZOMATO.RAW TO ROLE ZOMATO_ROLE;
GRANT ALL ON SCHEMA ZOMATO.STAGING TO ROLE ZOMATO_ROLE;
GRANT ALL ON SCHEMA ZOMATO.MARTS TO ROLE ZOMATO_ROLE;
GRANT ALL ON SCHEMA ZOMATO.SNAPSHOT TO ROLE ZOMATO_ROLE;