"""
Zomato Enterprise Batch ELT Pipeline
Orchestrates Bronze S3 ingestion -> Silver dbt staging -> Gold dbt marts -> Integrity Tests
"""

from datetime import datetime, timedelta
import logging
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator

default_args = {
    'owner': 'data_engineering',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

def log_pipeline_success(**context):
    execution_date = context.get('ds')
    logging.info(f"Zomato daily ELT batch pipeline completed successfully for date: {execution_date}")

with DAG(
    dag_id='zomato_daily_batch_pipeline',
    default_args=default_args,
    description='Daily automated ELT pipeline for Zomato delivery transactions and review intelligence',
    schedule='0 3 * * *',  # Runs daily at 03:00 UTC (after previous day settlements)
    catchup=False,         # Prevents runaway backfill runs on initialization
    max_active_runs=1,     # Guarantees sequential incremental watermarks
    tags=['zomato', 'snowflake', 'dbt', 'production'],
) as dag:

    # 1. Bronze Layer Ingestion (Idempotent COPY INTO via Snowflake)
    ingest_bronze_tables = SnowflakeOperator(
        task_id='ingest_bronze_tables',
        snowflake_conn_id='snowflake_zomato_conn',
        sql='snowflake/05_copy_into.sql',
    )

    # 2. Silver Layer Transformation (dbt Staging Views)
    dbt_run_staging = BashOperator(
        task_id='dbt_run_staging',
        bash_command='cd /opt/airflow/dbt/zomato && dbt run --select staging',
    )

    # 3. Silver Layer Quality Gate (Fail-Fast Data Validation)
    dbt_test_staging = BashOperator(
        task_id='dbt_test_staging',
        bash_command='cd /opt/airflow/dbt/zomato && dbt test --select staging',
    )

    # 4. Gold Layer Transformation (Incremental Facts & Conformed Dims)
    dbt_run_marts = BashOperator(
        task_id='dbt_run_marts',
        bash_command='cd /opt/airflow/dbt/zomato && dbt run --select marts',
    )

    # 5. Gold Layer Quality Gate (Referential Integrity & Range Tests)
    dbt_test_marts = BashOperator(
        task_id='dbt_test_marts',
        bash_command='cd /opt/airflow/dbt/zomato && dbt test --select marts',
    )

    # 6. Audit & Completion
    pipeline_completed = PythonOperator(
        task_id='pipeline_completed',
        python_callable=log_pipeline_success,
    )

    # Directed Acyclic Graph Dependencies
    ingest_bronze_tables >> dbt_run_staging >> dbt_test_staging >> dbt_run_marts >> dbt_test_marts >> pipeline_completed