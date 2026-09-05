# Zomato Enterprise Data Platform & Analytics Lakehouse

An end-to-end modern data engineering platform simulating high-throughput food delivery data operations (~10M+ orders, ~23M order items). 

## Architecture Stack
- **Data Lake & Ingestion:** AWS S3, Snowflake External Stages, COPY INTO (Bronze)
- **Data Warehouse:** Snowflake (Medallion Architecture: RAW, STAGING, MARTS)
- **Data Transformation:** dbt Core (Views, Incremental Merge Models, Schema Tests)
- **Orchestration:** Apache Airflow 3 (Dockerized DAG)

## Repository Layout
- snowflake/: Database DDLs, warehouse sizing, storage integration, and raw stage creation.
- zomato/: dbt project containing staging views (Silver) and dimensional marts (Gold).
- irflow/: Production batch DAG and containerization setup.

*Note: Comprehensive architecture documentation, schema lineage, and execution guides are being compiled in subsequent commits.*
