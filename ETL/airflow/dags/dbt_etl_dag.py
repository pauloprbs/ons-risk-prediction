from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_PROJECT_DIR = "/dbt_projeto"

default_args = {
    "owner": "airflow",
    "start_date": datetime(2024, 1, 1),
    "retries": 1,
}

with DAG(
    dag_id="dbt_etl_pipeline",
    default_args=default_args,
    schedule_interval=None,  # manual trigger
    catchup=False,
    tags=["dbt", "etl", "snowflake"],
) as dag:

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test",
    )

    dbt_run >> dbt_test