# -*- coding: utf-8 -*-
# airflow/dags/export_fact_to_gcs_alternativa.py

import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator

import pandas as pd
import snowflake.connector

# Configurações
DBT_PROJECT_DIR = "/dbt_projeto"
GCS_BUCKET_NAME = "projeto-etl-m2-fatos"
LOCAL_CSV_PATH = "/tmp/fct_geracao_energia.csv"
SNOWFLAKE_QUERY = "SELECT * FROM RAW_DATA.BR_ENERGY_DATA.V_FCT_GERACAO_ENERGIA"

# Função Python para exportar dados do Snowflake para CSV local
def export_snowflake_to_csv():
    conn = snowflake.connector.connect(
        user="ETL_USER",
        password="NovaSenha@123.456",
        account="hcummsm-jv25472",  
        warehouse="ETL_WH",
        database="RAW_DATA",
        schema="BR_ENERGY_DATA",
        role="ETL_ROLE"
    )
    df = pd.read_sql(SNOWFLAKE_QUERY, conn)
    df.to_csv(LOCAL_CSV_PATH, index=False)
    conn.close()

with DAG(
    dag_id="export_fact_to_gcs_alternativa",
    start_date=pendulum.datetime(2024, 1, 1, tz="UTC"),
    schedule="@daily",
    catchup=False,
    tags=["dbt", "export", "gcs", "snowflake"],
) as dag:

    dbt_build = BashOperator(
        task_id="dbt_build",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt build",
    )

    extract_to_csv = PythonOperator(
        task_id="extract_snowflake_to_csv",
        python_callable=export_snowflake_to_csv,
    )

    upload_to_gcs = LocalFilesystemToGCSOperator(
        task_id="upload_csv_to_gcs",
        src=LOCAL_CSV_PATH,
        dst="facts/fct_geracao_energia_{{ ds_nodash }}.csv",
        bucket=GCS_BUCKET_NAME,
        mime_type="text/csv",
    )

    dbt_build >> extract_to_csv >> upload_to_gcs
