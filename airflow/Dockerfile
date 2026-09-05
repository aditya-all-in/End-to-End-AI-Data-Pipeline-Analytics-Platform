FROM apache/airflow:2.10.0-python3.10

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER airflow
# Install dbt-snowflake and relevant database drivers
RUN pip install --no-cache-dir \
    dbt-core==1.8.7 \
    dbt-snowflake==1.8.3 \
    apache-airflow-providers-snowflake==5.8.0