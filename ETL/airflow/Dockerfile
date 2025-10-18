FROM apache/airflow:2.8.1

USER root
RUN apt-get update && apt-get install -y git

USER airflow
RUN pip install dbt-snowflake