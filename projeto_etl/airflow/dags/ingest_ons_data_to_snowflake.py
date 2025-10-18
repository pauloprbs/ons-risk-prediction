# -*- coding: utf-8 -*-
# airflow/dags/ingest_ons_data_to_snowflake.py

import pendulum
import pandas as pd
import requests
from io import StringIO
import logging
from sqlalchemy import text

from airflow.decorators import dag, task
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook

# --- CONFIGURAÇÕES GLOBAIS ---
SNOWFLAKE_CONN_ID = "snowflake_default" # ID padrão da conexão do Airflow com o Snowflake
RAW_DATABASE = "RAW_DATA"
RAW_SCHEMA = "BR_ENERGY_DATA"

# --- DEFINIÇÃO DA DAG ---
@dag(
    dag_id="ingest_ons_data_to_snowflake",
    start_date=pendulum.datetime(2024, 1, 1, tz="UTC"),
    schedule=None,  # Para ser executada apenas manualmente
    catchup=False,
    tags=["ingestion", "snowflake", "ons"],
    doc_md="""
    ### DAG de Ingestão de Dados da ONS para o Snowflake

    Esta DAG é responsável por baixar dados públicos da ONS e carregá-los
    nas tabelas correspondentes no banco de dados RAW_DATA do Snowflake.

    **Tarefas:**
    - `ingest_geracao_usina`: Baixa os arquivos mensais de geração por usina (2010-2023).
    - `ingest_fator_capacidade`: Baixa os arquivos mensais de fator de capacidade (2010-2023).
    - `ingest_interrupcao_carga`: Baixa o arquivo único de interrupção de carga.
    - `ingest_ear_subsistema`: Baixa o arquivo único de EAR por subsistema.

    A DAG é idempotente e verifica os dados existentes para evitar duplicatas.
    """
)
def ingest_ons_data_dag():
    """
    DAG para orquestrar a ingestão de dados da ONS para o Snowflake.
    """

    def get_snowflake_hook():
        """Cria e retorna um hook para o Snowflake."""
        return SnowflakeHook(snowflake_conn_id=SNOWFLAKE_CONN_ID)

    def generate_monthly_urls(base_url, start_year, end_year):
        """Gera uma lista de URLs mensais para um determinado período."""
        urls = []
        for year in range(start_year, end_year + 1):
            for month in range(1, 13):
                url = base_url.format(year=year, month=f"{month:02d}")
                urls.append(url)
        return urls

    def load_csv_to_snowflake(df, table_name, unique_columns):
        """
        Carrega um DataFrame para uma tabela no Snowflake, evitando duplicatas.
        Usa uma tabela temporária e SQLAlchemy para um merge eficiente.
        """
        if df.empty:
            logging.info(f"DataFrame para a tabela {table_name} está vazio. Nenhuma ação será tomada.")
            return

        hook = get_snowflake_hook()
        engine = hook.get_sqlalchemy_engine()
        
        temp_table = f"TEMP_{table_name.upper()}_{pd.Timestamp.now().strftime('%Y%m%d%H%M%S')}"
        
        # O with engine.connect() as conn gerencia a transação (commit/rollback) automaticamente.
        with engine.connect() as conn:
            try:
                logging.info(f"Criando tabela temporária: {temp_table}")
                conn.execute(text(f'CREATE TEMP TABLE "{temp_table}" LIKE "{RAW_DATABASE}"."{RAW_SCHEMA}"."{table_name}";'))
                
                df.to_sql(temp_table, conn, if_exists='append', index=False, chunksize=10000)
                logging.info(f"{len(df)} linhas inseridas na tabela temporária {temp_table}.")
                
                merge_condition = " AND ".join([f'target."{col}" = source."{col}"' for col in unique_columns])
                target_columns = ', '.join([f'"{col}"' for col in df.columns])
                source_columns = ', '.join([f'source."{col}"' for col in df.columns])

                merge_sql = f"""
                MERGE INTO "{RAW_DATABASE}"."{RAW_SCHEMA}"."{table_name}" AS target
                USING "{temp_table}" AS source
                ON {merge_condition}
                WHEN NOT MATCHED THEN
                  INSERT ({target_columns})
                  VALUES ({source_columns});
                """
                
                logging.info(f"Executando MERGE para a tabela {table_name}...")
                result = conn.execute(text(merge_sql))
                logging.info(f"MERGE concluído. {result.rowcount} linhas afetadas.")
                
                # **CORREÇÃO APLICADA AQUI:** conn.commit() removido. O 'with' lida com isso.
                
            except Exception as e:
                logging.error(f"Ocorreu um erro durante a transação: {e}")
                # **CORREÇÃO APLICADA AQUI:** conn.rollback() removido. O 'with' lida com isso.
                raise

    @task
    def ingest_geracao_usina():
        """
        Ingere dados mensais de geração por usina de 2010 a 2023.
        """
        base_url = "https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_{year}_{month}.csv"
        urls = generate_monthly_urls(base_url, 2010, 2023)
        
        all_dfs = []
        for url in urls:
            try:
                logging.info(f"Baixando dados de: {url}")
                response = requests.get(url)
                response.raise_for_status()
                df = pd.read_csv(StringIO(response.text), sep=';')
                all_dfs.append(df)
            except requests.exceptions.HTTPError as e:
                logging.warning(f"Não foi possível baixar o arquivo de {url}. Erro: {e}. Ignorando.")
            except Exception as e:
                logging.error(f"Ocorreu um erro inesperado ao processar {url}: {e}")

        if not all_dfs:
            logging.info("Nenhum dado de 'Geração Usina' foi baixado.")
            return

        full_df = pd.concat(all_dfs, ignore_index=True)
        full_df.columns = [
            "din_instante", "id_subsistema", "nom_subsistema", "id_estado", "nom_estado",
            "cod_modalidadeoperacao", "nom_tipousina", "nom_tipocombustivel", "nom_usina",
            "id_ons", "ceg", "val_geracao"
        ]
        
        full_df.columns = [col.upper() for col in full_df.columns]
        
        load_csv_to_snowflake(
            df=full_df, 
            table_name="GERACAO_USINA", 
            unique_columns=["DIN_INSTANTE", "ID_ONS", "CEG"]
        )

    @task
    def ingest_fator_capacidade():
        """
        Ingere dados mensais de fator de capacidade de 2010 a 2023.
        """
        base_url = "https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_{year}_{month}.csv"
        urls = generate_monthly_urls(base_url, 2010, 2023)
        
        all_dfs = []
        for url in urls:
            try:
                logging.info(f"Baixando dados de: {url}")
                response = requests.get(url)
                response.raise_for_status()
                df = pd.read_csv(StringIO(response.text), sep=';')
                all_dfs.append(df)
            except requests.exceptions.HTTPError as e:
                logging.warning(f"Não foi possível baixar o arquivo de {url}. Erro: {e}. Ignorando.")
            except Exception as e:
                logging.error(f"Ocorreu um erro inesperado ao processar {url}: {e}")

        if not all_dfs:
            logging.info("Nenhum dado de 'Fator Capacidade' foi baixado.")
            return
            
        full_df = pd.concat(all_dfs, ignore_index=True)
        full_df.columns = [
            "id_subsistema", "nom_subsistema", "id_estado", "nom_estado", "cod_pontoconexao",
            "nom_pontoconexao", "nom_localizacao", "val_latitudesecoletora", "val_longitudesecoletora",
            "val_latitudepontoconexao", "val_longitudepontoconexao", "nom_modalidadeoperacao",
            "nom_tipousina", "nom_usina_conjunto", "din_instante", "id_ons", "ceg",
            "val_geracaoprogramada", "val_geracaoverificada", "val_capacidadeinstalada",
            "val_fatorcapacidade"
        ]
        
        full_df.columns = [col.upper() for col in full_df.columns]
        
        load_csv_to_snowflake(
            df=full_df, 
            table_name="FATOR_CAPACIDADE",
            unique_columns=["DIN_INSTANTE", "ID_ONS", "CEG"]
        )

    @task
    def ingest_interrupcao_carga():
        """
        Ingere o arquivo único de interrupção de carga.
        """
        url = "https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/interrupcao_carga/INTERRUPCAO_CARGA.csv"
        try:
            logging.info(f"Baixando dados de: {url}")
            response = requests.get(url)
            response.raise_for_status()
            df = pd.read_csv(StringIO(response.text), sep=';')
            df.columns = [
                "cod_perturbacao", "din_interrupcaocarga", "id_subsistema", "nom_subsistema",
                "id_estado", "nom_agente", "val_cargainterrompida_mw", "val_tempomedio_minutos",
                "val_energianaosuprida_mwh", "flg_envolveuredebasica", "flg_envolveuredeoperacao"
            ]
            
            df.columns = [col.upper() for col in df.columns]
            
            load_csv_to_snowflake(
                df=df, 
                table_name="INTERRUPCAO_CARGA",
                unique_columns=["COD_PERTURBACAO", "DIN_INTERRUPCAOCARGA"]
            )
        except Exception as e:
            logging.error(f"Falha ao processar {url}: {e}")
            raise

    @task
    def ingest_ear_subsistema():
        """
        Ingere o arquivo de EAR por subsistema.
        """
        base_url = "https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/ear_subsistema_di/EAR_DIARIO_SUBSISTEMA_{year}.csv"
        urls = [base_url.format(year=y) for y in range(2010, 2025)]

        all_dfs = []
        for url in urls:
            try:
                logging.info(f"Baixando dados de: {url}")
                response = requests.get(url)
                response.raise_for_status()
                df = pd.read_csv(StringIO(response.text), sep=';')
                all_dfs.append(df)
            except requests.exceptions.HTTPError as e:
                logging.warning(f"Não foi possível baixar o arquivo de {url}. Erro: {e}. Ignorando.")
            except Exception as e:
                logging.error(f"Ocorreu um erro inesperado ao processar {url}: {e}")
        
        if not all_dfs:
            logging.info("Nenhum dado de 'EAR Subsistema' foi baixado.")
            return

        full_df = pd.concat(all_dfs, ignore_index=True)
        full_df.columns = [
            "id_subsistema", "nom_subsistema", "ear_data",
            "ear_max_subsistema", "ear_verif_subsistema_mwmes", "ear_verif_subsistema_percentual"
        ]
        
        full_df.columns = [col.upper() for col in full_df.columns]
        
        load_csv_to_snowflake(
            df=full_df, 
            table_name="EAR_DIARIO_SUBSISTEMA",
            unique_columns=["ID_SUBSISTEMA", "EAR_DATA"]
        )

    # Executa todas as tarefas de ingestão em paralelo
    [
        ingest_geracao_usina(), 
        ingest_fator_capacidade(), 
        ingest_interrupcao_carga(), 
        ingest_ear_subsistema()
    ]

# Instancia a DAG
ingest_ons_data_dag()
