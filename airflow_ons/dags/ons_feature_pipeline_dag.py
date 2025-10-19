from __future__ import annotations

import sys
import os
from datetime import datetime
from airflow.decorators import dag, task
from airflow.operators.bash import BashOperator  # <--- Re-importe o BashOperator

# -----------------------------------------------------------------
# 1. PREPARAÇÃO: (Seu código original, está correto)
# -----------------------------------------------------------------
PROJECT_ROOT_PATH = '/opt/airflow/../' 
SCRIPT_PATH = os.path.join(PROJECT_ROOT_PATH, 'scripts')
sys.path.append(SCRIPT_PATH)

try:
    from extract_carga_api import extract_carga_main
    from download_weather_data import download_clima_main
except ImportError as e:
    print(f"Erro ao importar scripts de extração: {e}")
    def extract_carga_main(): pass
    def download_clima_main(): pass

# -----------------------------------------------------------------
# 2. CONFIGURAÇÃO DO DBT (Seu código original, está correto)
# -----------------------------------------------------------------
DBT_PROJECT_DIR = '/opt/airflow/dbt_ons'
DBT_PROFILES_DIR = '/opt/airflow/dbt_ons' 

@dag(
    dag_id='ons_feature_pipeline_dag',
    start_date=datetime(2024, 1, 1),
    schedule_interval='@daily',
    catchup=False,
    tags=['ons_project', 'dbt', 'ml']
)
def ons_feature_pipeline():
    """
    DAG para orquestrar o pipeline de dados completo do projeto ONS:
    1. Extrai dados de APIs (Carga e Clima).
    2. Executa as transformações com dbt.
    """

    # -----------------------------------------------------------------
    # 3. TAREFAS DE EXTRAÇÃO (Extract) - (Seu código original)
    # -----------------------------------------------------------------
    
    @task(task_id='extract_carga_api')
    def task_extract_carga():
        print("Iniciando extração da API de Carga ONS...")
        extract_carga_main()
        print("Extração de Carga concluída.")

    @task(task_id='download_weather_data')
    def task_download_clima():
        print("Iniciando download da API de Clima (NASA POWER)...")
        download_clima_main()
        print("Download de Clima concluído.")

    # -----------------------------------------------------------------
    # 4. TAREFAS DE TRANSFORMAÇÃO (Transform) - <<< CORREÇÃO AQUI
    # -----------------------------------------------------------------
    
    # Volte a usar o BashOperator. 
    # Agora ele funciona, pois 'dbt' está na imagem.
    task_dbt_run = BashOperator(
        task_id='dbt_run_transformations',
        # O f-string funciona aqui pois é avaliado ao carregar o DAG
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --profiles-dir {DBT_PROFILES_DIR}"
    )

    task_dbt_test = BashOperator(
        task_id='dbt_test_data_quality',
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --profiles-dir {DBT_PROFILES_DIR}"
    )

    # -----------------------------------------------------------------
    # 5. DEFINIÇÃO DE DEPENDÊNCIAS - <<< CORREÇÃO AQUI
    # -----------------------------------------------------------------
    
    # Use as variáveis das tasks do BashOperator
    [task_extract_carga(), task_download_clima()] >> task_dbt_run >> task_dbt_test

# Invoca a função para registrar o DAG
ons_feature_pipeline()