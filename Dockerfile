# 1. Use a mesma imagem base
FROM apache/airflow:2.7.0

RUN pip install --no-cache-dir dbt-snowflake