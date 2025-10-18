# Fontes de dados - exemplos:
## Base de dados: Interrupção de Carga
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/interrupcao_carga/INTERRUPCAO_CARGA.csv
```

## geração por usina
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_12.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_11.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_10.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_09.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_08.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_07.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_06.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_05.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_04.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_03.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_02.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/geracao_usina_2_ho/GERACAO_USINA-2_2024_01.csv
```

## EAR Diário por Subsistema 
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/ear_subsistema_di/EAR_DIARIO_SUBSISTEMA_2024.csv
``` 

## Fator de capacidade
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_12.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_11.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_10.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_09.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_08.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_07.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_06.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_05.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_04.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_03.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_02.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/fator_capacidade_2_di/FATOR_CAPACIDADE-2_2024_01.csv
```

## RESTRIÇÃO DE OPERAÇÃO POR CONSTRAINED-OFF DE USINAS EÓLICAS – DETALHAMENTO POR USINA

```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/restricao_coff_eolica_detail_tm/RESTRICAO_COFF_EOLICA_DETAIL_2025_10.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/restricao_coff_eolica_detail_tm/RESTRICAO_COFF_EOLICA_DETAIL_2025_09.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/restricao_coff_eolica_detail_tm/RESTRICAO_COFF_EOLICA_DETAIL_2025_08.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/restricao_coff_eolica_detail_tm/RESTRICAO_COFF_EOLICA_DETAIL_2025_07.csv
```

## Ena diário por subsistema
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/ena_subsistema_di/ENA_DIARIO_SUBSISTEMA_2025.csv
```

## DADOS DE INTERCÂMBIOS ENTRE SUBSISTEMAS
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/intercambio_nacional_ho/INTERCAMBIO_NACIONAL_2025.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/intercambio_nacional_ho/INTERCAMBIO_NACIONAL_2024.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/intercambio_nacional_ho/INTERCAMBIO_NACIONAL_2023.csv
```
## DADOS DO CMO SEMANAL

```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/cmo_se/CMO_SEMANAL_2025.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/cmo_se/CMO_SEMANAL_2024.csv
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/cmo_se/CMO_SEMANAL_2023.csv
```

## DADOS DOS INDICADORES DE CONFIABILIDADE DA REDE BÁSICA: CCAL
```
https://ons-aws-prod-opendata.s3.amazonaws.com/dataset/ind_confiarb_ccal/IND_CONFIARB_CCAL.csv
```

## Estrutura da pasta:
```
projeto_etl/
├── docker-compose.yml
├── airflow/
│   └── keys/
│   └── dags/
│       └── dbt_etl_dag.py
│       └── export_fact_to_gcs_dag.py
│       └── export_fact_to_gcs_parquet_dag.py
│   └── Dockerfile
│   └── requirements.txt
├── snowflake_setup/
│   └── setup.sql
└── dbt_projeto/
    ├── models/
    │   ├── staging/
    │   │   ├── stg_ear_diario.sql
    │   │   ├── stg_fator_capacidade.sql
    │   │   ├── stg_geracao_usina.sql
    │   │   └── stg_interrupcao_carga.sql
    │   │   └── stg_cmo_semanal.sql
    │   │   └── stg_ena_diario_subsistema.sql
    │   │   └── stg_ind_confiabilidade_ccal.sql
    │   │   └── stg_intercambio_subsistema.sql
    │   │   └── stg_restricao_eolica.sql
    │   └── marts/
    │       ├── dimensions/
    │       │   ├── dim_localizacao.sql
    │       │   ├── dim_tempo.sql
    │       │   └── dim_usina.sql
    │       └── facts/
    │           └── fct_geracao_energia.sql
    │           └── fct_confiabilidade_rede.sql
    │           └── fct_intercambio_energetico.sql
    └── dbt_project.yml

```

## docker-compose.yml
```
#yaml name=docker-compose.yml
version: '3.7'
services:
  postgres:
    image: postgres:13
    environment:
      POSTGRES_USER: airflow
      POSTGRES_PASSWORD: airflow
      POSTGRES_DB: airflow
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "airflow"]
      interval: 5s
      retries: 5

  airflow-webserver:
    build:
      context: ./airflow
    image: apache/airflow:2.8.1
    depends_on:
      - postgres
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
      AIRFLOW__CORE__FERNET_KEY: ''
      AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: 'true'
      AIRFLOW__CORE__LOAD_EXAMPLES: 'false'
      AIRFLOW__WEBSERVER__PORT: 8080
      AIRFLOW__CORE__DEFAULT_TIMEZONE: UTC
      AIRFLOW__WEBSERVER__SECRET_KEY: "minha-chave-secreta-supersegura"
    volumes:
      - ./airflow/dags:/opt/airflow/dags
      - ./dbt_projeto:/dbt_projeto
      - ./airflow/.dbt:/home/airflow/.dbt
    ports:
      - "8080:8080"
    command: webserver
    restart: always

  airflow-scheduler:
    build:
      context: ./airflow
    image: apache/airflow:2.8.1
    depends_on:
      - postgres
      - airflow-webserver
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
      AIRFLOW__WEBSERVER__SECRET_KEY: "minha-chave-secreta-supersegura"
    volumes:
      - ./airflow/dags:/opt/airflow/dags
      - ./dbt_projeto:/dbt_projeto
      - ./airflow/.dbt:/home/airflow/.dbt
    command: scheduler
    restart: always

  airflow-init:
    build:
      context: ./airflow
    image: apache/airflow:2.8.1
    depends_on:
      - postgres
    environment:
      AIRFLOW__CORE__EXECUTOR: LocalExecutor
      AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://airflow:airflow@postgres/airflow
    volumes:
      - ./airflow/dags:/opt/airflow/dags
      - ./dbt_projeto:/dbt_projeto
      - ./airflow/.dbt:/home/airflow/.dbt
    command: bash -c "airflow db migrate && airflow users create --username admin --password admin --firstname Admin --lastname User --role Admin --email admin@admin.com"
```

## airflow/Dockerfile
```
# airflow/Dockerfile
FROM apache/airflow:2.8.1


USER root
RUN apt-get update && apt-get install -y git

USER airflow
# Adicionamos o provider do Google
RUN pip install gcsfs dbt-snowflake apache-airflow apache-airflow-providers-snowflake apache-airflow-providers-google

```

## airflow/requirements.txt
```
dbt-snowflake
pandas
snowflake-connector-python
apache-airflow-providers-google
apache-airflow-providers-snowflake

```

## airflow/dags/dbt_etl_dag.py
```
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
```

## airflow/dags/dbt_etl_dag.py
```
# -*- coding: utf-8 -*-
# airflow/dags/export_fact_to_gcs_alternativa.py

import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator

import pandas as pd
import snowflake.connector

# ConfiguraÃ§Ãµes
DBT_PROJECT_DIR = "/dbt_projeto"
GCS_BUCKET_NAME = "projeto-etl-m2-fatos"
LOCAL_CSV_PATH = "/tmp/fct_geracao_energia.csv"
SNOWFLAKE_QUERY = "SELECT * FROM RAW_DATA.BR_ENERGY_DATA.V_FCT_GERACAO_ENERGIA"

# FunÃ§Ã£o Python para exportar dados do Snowflake para CSV local
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

```


## snowflake_setup/setup.sql

```
-- projeto_etl/snowflake_setup/setup.sql: 
-- Ativar role administrativa
USE ROLE ACCOUNTADMIN;

-- Criar role para ETL
CREATE ROLE IF NOT EXISTS ETL_ROLE;

-- Criar warehouse para ETL
CREATE WAREHOUSE IF NOT EXISTS ETL_WH
  WITH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 600 -- Suspende após 60 segundos de inatividade
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE
  COMMENT = 'Warehouse para o projeto de ETL de dados de energia';

-- Criar usuário para ETL
CREATE USER IF NOT EXISTS ETL_USER
  PASSWORD = 'NovaSenha@123.456'
  DEFAULT_WAREHOUSE = 'ETL_WH'
  DEFAULT_ROLE = 'ETL_ROLE'
  MUST_CHANGE_PASSWORD = FALSE
  COMMENT = 'Usuário para integração ETL';

-- Conceder role ETL ao usuário e à role administrativa
GRANT ROLE ETL_ROLE TO USER ETL_USER;
GRANT ROLE ACCOUNTADMIN TO USER ETL_USER;

-- Opcional: conceder também SYSADMIN (não necessário se usar ACCOUNTADMIN)
GRANT ROLE SYSADMIN TO USER ETL_USER;

-- Conceder todas as permissões no warehouse
GRANT ALL PRIVILEGES ON WAREHOUSE ETL_WH TO ROLE ETL_ROLE;

-- Criar databases e schemas
CREATE DATABASE IF NOT EXISTS RAW_DATA;
CREATE SCHEMA IF NOT EXISTS RAW_DATA.BR_ENERGY_DATA;

CREATE DATABASE IF NOT EXISTS ANALYTICS;
CREATE SCHEMA IF NOT EXISTS ANALYTICS.BR_ENERGY_MART;

-- Conceder todas as permissões nos bancos e schemas
GRANT ALL PRIVILEGES ON DATABASE RAW_DATA TO ROLE ETL_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA RAW_DATA.BR_ENERGY_DATA TO ROLE ETL_ROLE;

GRANT ALL PRIVILEGES ON DATABASE ANALYTICS TO ROLE ETL_ROLE;
GRANT ALL PRIVILEGES ON SCHEMA ANALYTICS.BR_ENERGY_MART TO ROLE ETL_ROLE;

-- Permissões máximas futuras para objetos criados posteriormente
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA RAW_DATA.BR_ENERGY_DATA TO ROLE ETL_ROLE;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN SCHEMA ANALYTICS.BR_ENERGY_MART TO ROLE ETL_ROLE;

GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE RAW_DATA TO ROLE ETL_ROLE;
GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE ANALYTICS TO ROLE ETL_ROLE;

GRANT ALL PRIVILEGES ON FUTURE STAGES IN SCHEMA RAW_DATA.BR_ENERGY_DATA TO ROLE ETL_ROLE;
GRANT ALL PRIVILEGES ON FUTURE STAGES IN SCHEMA ANALYTICS.BR_ENERGY_MART TO ROLE ETL_ROLE;


--GRANT ROLE ETL_ROLE TO USER CASCABRAL75L2;
-- Executar como ACCOUNTADMIN:
CREATE ROLE IF NOT EXISTS ETL_ROLE;
GRANT ROLE ETL_ROLE TO USER ETL_USER;


-- Tornar role e warehouse ativos para criar tabelas
USE ROLE ETL_ROLE;
USE WAREHOUSE ETL_WH;
USE SCHEMA RAW_DATA.BR_ENERGY_DATA;

-- Criar tabelas
CREATE TABLE IF NOT EXISTS GERACAO_USINA (
    din_instante TIMESTAMP_NTZ,
    id_subsistema VARCHAR(3),
    nom_subsistema VARCHAR(20),
    id_estado VARCHAR(2),
    nom_estado VARCHAR(30),
    cod_modalidadeoperacao VARCHAR(20),
    nom_tipousina VARCHAR(30),
    nom_tipocombustivel VARCHAR(50),
    nom_usina VARCHAR(60),
    id_ons VARCHAR(32),
    ceg VARCHAR(30),
    val_geracao FLOAT
);

CREATE TABLE IF NOT EXISTS FATOR_CAPACIDADE (
    id_subsistema VARCHAR(2),
    nom_subsistema VARCHAR(60),
    id_estado VARCHAR(2),
    nom_estado VARCHAR(30),
    cod_pontoconexao VARCHAR(11),
    nom_pontoconexao VARCHAR(45),
    nom_localizacao VARCHAR(20),
    val_latitudesecoletora FLOAT,
    val_longitudesecoletora FLOAT,
    val_latitudepontoconexao FLOAT,
    val_longitudepontoconexao FLOAT,
    nom_modalidadeoperacao VARCHAR(20),
    nom_tipousina VARCHAR(30),
    nom_usina_conjunto VARCHAR(60),
    din_instante TIMESTAMP_NTZ,
    id_ons VARCHAR(6),
    ceg VARCHAR(30),
    val_geracaoprogramada FLOAT,
    val_geracaoverificada FLOAT,
    val_capacidadeinstalada FLOAT,
    val_fatorcapacidade FLOAT
);

CREATE TABLE IF NOT EXISTS INTERRUPCAO_CARGA (
    cod_perturbacao VARCHAR(12),
    din_interrupcaocarga TIMESTAMP_NTZ,
    id_subsistema VARCHAR(2),
    nom_subsistema VARCHAR(60),
    id_estado VARCHAR(2),
    nom_agente VARCHAR(30),
    val_cargainterrompida_mw FLOAT,
    val_tempomedio_minutos FLOAT,
    val_energianaosuprida_mwh FLOAT,
    flg_envolveuredebasica VARCHAR(1),
    flg_envolveuredeoperacao VARCHAR(1)
);

CREATE TABLE IF NOT EXISTS EAR_DIARIO_SUBSISTEMA (
    id_subsistema VARCHAR(2),
    nom_subsistema VARCHAR(20),
    ear_data DATE,
    ear_max_subsistema FLOAT,
    ear_verif_subsistema_mwmes FLOAT,
    ear_verif_subsistema_percentual FLOAT
);


ALTER TABLE RAW_DATA.BR_ENERGY_DATA.FATOR_CAPACIDADE 
MODIFY COLUMN id_ons VARCHAR(40);


ALTER TABLE RAW_DATA.BR_ENERGY_DATA.GERACAO_USINA
MODIFY COLUMN cod_modalidadeoperacao VARCHAR(60);

```

## dbt_projeto/dbt_project.yml
```
# projeto_etl/dbt_projeto/dbt_project.yml
name: 'dbt_projeto'
version: '1.0.0'
config-version: 2

profile: 'dbt_projeto'

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

target-path: "target"
clean-targets:
  - "target"
  - "dbt_packages"

vars:
  raw_database: RAW_DATA
  raw_schema: BR_ENERGY_DATA

models:
  dbt_projeto:
    staging:
      +materialized: view
    marts:
      dimensions:
        +materialized: table
      facts:
        +materialized: table

```

## dbt_projeto/packages.yml
```
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

## dbt_projeto/models/staging/staging.yml
```
# projeto_etl/dbt_projeto/models/staging/staging.yml
version: 2

models:
  - name: stg_ear_diario_subsistema
    description: "Modelo de staging para os dados de Energia Armazenada (EAR) diária."
    columns:
      - name: id_subsistema
        tests:
          - not_null
      - name: data_medicao
        tests:
          - not_null

  - name: stg_fator_capacidade
    description: "Modelo de staging para os dados de fator de capacidade das usinas."
    columns:
      - name: id_ons
        tests:
          - not_null
      - name: instante_medicao
        tests:
          - not_null

  - name: stg_geracao_usina
    description: "Modelo de staging para os dados de geração de energia por usina."
    columns:
      - name: id_ons
        tests:
          - not_null
      - name: instante_geracao
        tests:
          - not_null

  - name: stg_interrupcao_carga
    description: "Modelo de staging para os dados de interrupção de carga."
    columns:
      - name: id_perturbacao
        tests:
          - not_null
          - unique

  - name: stg_restricao_eolica
    description: "Prepara os dados de restrição de operação de usinas eólicas."
    columns:
      - name: instante_medicao
        description: "Chave temporal da medição."
        tests:
          - not_null
      - name: id_ons
        description: "Identificador da usina no ONS."
        tests:
          - not_null
      - name: ceg
        description: "Código único do empreendimento (CEG)."
        tests:
          - not_null

  - name: stg_ena_diario_subsistema
    description: "Prepara os dados diários de Energia Natural Afluente por subsistema."
    columns:
      - name: data_medicao
        description: "Chave de data da medição."
        tests:
          - not_null
      - name: id_subsistema
        description: "Chave do subsistema."
        tests:
          - not_null

  - name: stg_intercambio_subsistema
    description: "Prepara os dados horários de intercâmbio de energia entre subsistemas."
    columns:
      - name: instante_medicao
        description: "Chave temporal da medição."
        tests:
          - not_null
      - name: id_subsistema_origem
        description: "Identificador do subsistema de origem."
        tests:
          - not_null
      - name: id_subsistema_destino
        description: "Identificador do subsistema de destino."
        tests:
          - not_null

  - name: stg_cmo_semanal
    description: "Prepara os dados semanais de Custo Marginal de Operação."
    columns:
      - name: data_semana
        description: "Chave de data da semana operativa."
        tests:
          - not_null
      - name: id_subsistema
        description: "Chave do subsistema."
        tests:
          - not_null

  - name: stg_ind_confiabilidade_ccal
    description: "Prepara os dados do indicador de confiabilidade CCAL."
    columns:
      - name: data_referencia
        description: "Chave de data do indicador."
        tests:
          - not_null
      - name: periodicidade
        description: "Periodicidade do dado (Anual ou Mensal)."
        tests:
          - accepted_values:
              values: ['AN', 'ME']
```

## dbt_projeto/models/staging/sources.yml
```
# projeto_etl/dbt_projeto/models/staging/sources.yml
version: 2

sources:
  - name: BR_ENERGY_DATA
    database: "{{ var('raw_database', 'RAW_DATA') }}"
    schema: "{{ var('raw_schema', 'BR_ENERGY_DATA') }}"
    tables:
      # Fontes existentes
      - name: GERACAO_USINA
      - name: FATOR_CAPACIDADE
      - name: EAR_DIARIO_SUBSISTEMA
      - name: INTERRUPCAO_CARGA

      # --- NOVAS FONTES ---
      - name: RESTRICAO_EOLICA
        description: "Informações de restrições de operação por constrained-off em usinas eólicas."
        columns:
          - name: din_instante
            description: "Data e hora da medição."
          - name: id_subsistema
            description: "Identificador do Subsistema."
          - name: id_estado
            description: "Sigla do Estado."
          - name: id_ons
            description: "Identificador da Usina ou Conjunto no ONS."
          - name: ceg
            description: "Código Único do Empreendimento de Geração (ANEEL)."
          - name: nom_usina
            description: "Nome da Usina."
          - name: val_geracaoestimada
            description: "Geração estimada da usina, em MWmed."
          - name: val_geracaoverificada
            description: "Geração verificada da usina, em MWmed."

      - name: ENA_DIARIO_SUBSISTEMA
        description: "Dados de Energia Natural Afluente (ENA) em periodicidade diária por Subsistema."
        columns:
          - name: ena_data
            description: "Dia observado da medida."
          - name: id_subsistema
            description: "Código do Subsistema."
          - name: nom_subsistema
            description: "Nome do Subsistema."
          - name: ena_bruta_regiao_mwmed
            description: "Valor de ENA bruta por Subsistema em MWmês."
          - name: ena_armazenavel_regiao_mwmed
            description: "Valor de ENA armazenável por Subsistema em MWmês."

      - name: INTERCAMBIO_SUBSISTEMA
        description: "Dados de intercâmbio de energia entre subsistemas em base horária."
        columns:
          - name: din_instante
            description: "Data/hora de início do período."
          - name: id_subsistema_origem
            description: "Código do Subsistema de Origem."
          - name: id_subsistema_destino
            description: "Código do Subsistema de Destino."
          - name: val_intercambiomwmed
            description: "Intercâmbio verificado em MWmed."

      - name: CMO_SEMANAL
        description: "Custo Marginal de Operação (CMO) por semana operativa e subsistema."
        columns:
          - name: din_instante
            description: "Data de referência da Semana Operativa."
          - name: id_subsistema
            description: "Código do Subsistema."
          - name: val_cmomediasemanal
            description: "CMO Médio Semanal, em R$/MWh."
          - name: val_cmoleve
            description: "CMO no patamar de carga leve, em R$/MWh."
          - name: val_cmomedia
            description: "CMO no patamar de carga média, em R$/MWh."
          - name: val_cmopesada
            description: "CMO no patamar de carga pesada, em R$/MWh."

      - name: IND_CONFIABILIDADE_CCAL
        description: "Indicador de Controle de Carregamento de Linhas de Transmissão (CCAL)."
        columns:
          - name: din_referencia
            description: "Mês de referência do indicador."
          - name: cod_tipoagregacao
            description: "Tipo de agregação (SIN, COSR ou Agente)."
          - name: id_periodicidade
            description: "Periodicidade do indicador (AN: Anual, ME: Mensal)."
          - name: nom_agregacao
            description: "Nome da visão para a agregação."
          - name: num_linhasoperacao
            description: "Número de linhas de transmissão em operação."
          - name: num_linhasvioladas
            description: "Número de linhas de transmissão com sobrecarga."
          - name: val_ccal
            description: "Valor do indicador CCAL, em %."
```

## dbt_projeto/models/marts/marts.yml
```
# projeto_etl/dbt_projeto/models/marts/marts.yml
version: 2

models:
  # --- DIMENSIONS ---
  - name: dim_localizacao
    description: "Dimensão que agrega informações de localização (subsistema e estado)."
    columns:
      - name: id_localizacao
        description: "Chave primária da dimensão de localização."
        tests:
          - unique
          - not_null

  - name: dim_tempo
    description: "Dimensão que detalha informações temporais, com granularidade horária."
    columns:
      - name: id_tempo
        description: "Chave primária da dimensão de tempo (timestamp horário)."
        tests:
          - unique
          - not_null

  - name: dim_usina
    description: "Dimensão com os atributos das usinas geradoras de energia."
    columns:
      - name: id_usina
        description: "Chave primária da dimensão de usinas."
        tests:
          - unique
          - not_null

  # --- FACTS ---
  - name: fct_geracao_energia
    description: "Tabela fato principal, consolidando métricas horárias de geração, capacidade, restrição e custos por usina e localização."
    columns:
      - name: id_tempo
        description: "Chave estrangeira para a dimensão de tempo."
        tests:
          - not_null
          - relationships:
              to: ref('dim_tempo')
              field: id_tempo
      - name: id_localizacao
        description: "Chave estrangeira para a dimensão de localização."
        tests:
          - not_null
          - relationships:
              to: ref('dim_localizacao')
              field: id_localizacao
      - name: id_usina
        description: "Chave estrangeira para a dimensão de usina."
        tests:
          - not_null
          - relationships:
              to: ref('dim_usina')
              field: id_usina

  - name: fct_intercambio_energetico
    description: "Tabela fato com granularidade horária para o intercâmbio de energia entre subsistemas."
    columns:
      - name: id_tempo
        description: "Chave estrangeira para a dimensão de tempo."
        tests:
          - not_null
          - relationships:
              to: ref('dim_tempo')
              field: id_tempo
      - name: id_localizacao_origem
        description: "Chave estrangeira para a localização de origem."
        tests:
          - not_null
          - relationships:
              to: ref('dim_localizacao')
              field: id_localizacao
      - name: id_localizacao_destino
        description: "Chave estrangeira para a localização de destino."
        tests:
          - not_null
          - relationships:
              to: ref('dim_localizacao')
              field: id_localizacao

  - name: fct_confiabilidade_rede
    description: "Tabela fato com granularidade mensal/anual para os indicadores de confiabilidade da rede."
    columns:
      - name: id_fato_confiabilidade
        description: "Chave primária da tabela fato."
        tests:
          - unique
          - not_null
      - name: data_referencia
        description: "Data de referência para o indicador."
        tests:
          - not_null
```

## dbt_projeto/models/staging/stg_ear_diario.sql
```
-- projeto_etl/dbt_projeto/models/staging/stg_ear_diario.sql

select
    "ID_SUBSISTEMA" as id_subsistema, -- Código do Subsistema 
    "NOM_SUBSISTEMA" as nom_subsistema, -- Nome da Subsistema 
--   "EAR_DATA" as ear_data as data_medicao, -- Dia observado da medida
	"EAR_DATA" as data_medicao, -- Dia observado da medida
    "EAR_MAX_SUBSISTEMA" as ear_maxima_mwmes, -- Valor de EAR máxima por subsistema na unidade de medida MWmês
    "EAR_VERIF_SUBSISTEMA_MWMES" as ear_verificada_mwmes, -- Valor de EAR verificada no dia por subsistema na unidade de medida MWmês
    "EAR_VERIF_SUBSISTEMA_PERCENTUAL"  as ear_verificada_percentual -- Valor de EAR verificada no dia por subsistema na unidade de medida % 

from {{ source('BR_ENERGY_DATA', 'EAR_DIARIO_SUBSISTEMA') }}
```

## dbt_projeto/models/staging/stg_fator_capacidade.sql
```
 
select
    "DIN_INSTANTE"::timestamp as instante_medicao,
    "ID_SUBSISTEMA" as id_subsistema,
    "ID_ESTADO" as id_estado,
    "ID_ONS" as id_ons,
    "CEG" as ceg,
    "NOM_TIPOUSINA" as tipo_usina,
    "NOM_USINA_CONJUNTO" as nome_usina_conjunto,
    "VAL_CAPACIDADEINSTALADA" as capacidade_instalada_mw,
    "VAL_GERACAOVERIFICADA" as geracao_verificada_mwmed,
    "VAL_FATORCAPACIDADE" as fator_capacidade
from {{ source('BR_ENERGY_DATA', 'FATOR_CAPACIDADE') }}
```

## dbt_projeto/models/staging/stg_geracao_usina.sql
```
select
    "DIN_INSTANTE"::timestamp as instante_geracao,
    "ID_SUBSISTEMA" as id_subsistema,
    "ID_ESTADO" as id_estado,
    "ID_ONS" as id_ons,
    "CEG" as ceg,
    "NOM_TIPOUSINA" as tipo_usina,
    "NOM_TIPOCOMBUSTIVEL" as tipo_combustivel,
    "NOM_USINA" as nom_usina,
    "VAL_GERACAO" as geracao_mwmed
from {{ source('BR_ENERGY_DATA', 'GERACAO_USINA') }}

```

## dbt_projeto/models/staging/stg_interrupcao_carga.sql
```
-- local:  models/staging/stg_interrupcao_carga.sql

select
    "COD_PERTURBACAO" as id_perturbacao, -- Identificador da perturbação no Sistema Integrado de Perturbações
    "DIN_INTERRUPCAOCARGA" as instante_interrupcao, -- Instante da interrupção de carga
    "ID_SUBSISTEMA" as id_subsistema, -- Sigla do subsistema
    "NOM_SUBSISTEMA" as nom_subsistema, -- Nome do subsistema
    "ID_ESTADO" as id_estado, -- Sigla do estado
    "NOM_AGENTE" as nom_agente, -- Nome do agente afetado pela interrupção de carga
    "VAL_CARGAINTERROMPIDA_MW" as carga_interrompida_mw,
    "VAL_TEMPOMEDIO_MINUTOS" as tempo_recomposicao_minutos,
    "VAL_ENERGIANAOSUPRIDA_MWH" as energia_nao_suprida_mwh, 
    
    -- Converte S/N para True/False para facilitar a análise
    ("FLG_ENVOLVEUREDEBASICA" = 'S') as envolveu_rede_basica,
    ("FLG_ENVOLVEUREDEOPERACAO" = 'S') as envolveu_rede_operacao

from {{ source('BR_ENERGY_DATA', 'INTERRUPCAO_CARGA') }}
```

## dbt_projeto/models/staging/stg_restricao_eolica.sql
```
-- models/staging/stg_restricao_eolica.sql
select
    "DIN_INSTANTE"::timestamp as instante_medicao,
    "ID_SUBSISTEMA" as id_subsistema,
    "ID_ESTADO" as id_estado,
    "ID_ONS" as id_ons,
    "CEG" as ceg,
    "NOM_USINA" as nom_usina,
    "VAL_GERACAOESTIMADA" as geracao_estimada_mw,
    "VAL_GERACAOVERIFICADA" as geracao_verificada_mw
from {{ source('BR_ENERGY_DATA', 'RESTRICAO_EOLICA') }}
```
## dbt_projeto/models/staging/stg_ena_diario_subsistema.sql
```
-- models/staging/stg_ena_diario_subsistema.sql
select
    "ENA_DATA"::date as data_medicao,
    "ID_SUBSISTEMA" as id_subsistema,
    "NOM_SUBSISTEMA" as nom_subsistema,
    "ENA_BRUTA_REGIAO_MWMED" as ena_bruta_mwmed,
    "ENA_ARMAZENAVEL_REGIAO_MWMED" as ena_armazenavel_mwmed
from {{ source('BR_ENERGY_DATA', 'ENA_DIARIO_SUBSISTEMA') }}
```

## dbt_projeto/models/staging/stg_intercambio_subsistema.sql
```
-- models/staging/stg_intercambio_subsistema.sql
select
    "DIN_INSTANTE"::timestamp as instante_medicao,
    "ID_SUBSISTEMA_ORIGEM" as id_subsistema_origem,
    "ID_SUBSISTEMA_DESTINO" as id_subsistema_destino,
    "VAL_INTERCAMBIOMWMED" as intercambio_mwmed
from {{ source('BR_ENERGY_DATA', 'INTERCAMBIO_SUBSISTEMA') }}
```
## dbt_projeto/models/staging/stg_cmo_semanal.sql
```
-- models/staging/stg_cmo_semanal.sql
select
    "DIN_INSTANTE"::date as data_semana,
    "ID_SUBSISTEMA" as id_subsistema,
    "VAL_CMOMEDIASEMANAL" as cmo_medio_semanal_rs_mwh,
    "VAL_CMOLEVE" as cmo_patamar_leve_rs_mwh,
    "VAL_CMOMEDIA" as cmo_patamar_medio_rs_mwh,
    "VAL_CMOPESADA" as cmo_patamar_pesado_rs_mwh
from {{ source('BR_ENERGY_DATA', 'CMO_SEMANAL') }}
```

## dbt_projeto/models/staging/stg_ind_confiabilidade_ccal.sql
```
-- models/staging/stg_ind_confiabilidade_ccal.sql
select
    "DIN_REFERENCIA"::date as data_referencia,
    "COD_TIPOAGREGACAO" as tipo_agregacao, -- SIN, COSR ou Agente
    "ID_PERIODICIDADE" as periodicidade, -- AN (Anual), ME (Mensal)
    "NOM_AGREGACAO" as nome_agregacao, -- Nome da visão (SIN, COSR, Agente)
    "NUM_LINHASOPERACAO" as num_linhas_operacao,
    "NUM_LINHASVIOLADAS" as num_linhas_violadas,
    "VAL_CCAL" as indicador_ccal_percentual
from {{ source('BR_ENERGY_DATA', 'IND_CONFIABILIDADE_CCAL') }}
```

## dbt_projeto/models/marts/dimensions/dim_localizacao.sql
```
-- models/marts/dimensions/dim_localizacao.sql
with all_locations as (
    select distinct id_subsistema, id_estado from {{ ref('stg_geracao_usina') }}
    union
    select distinct id_subsistema, id_estado from {{ ref('stg_fator_capacidade') }}
    union
    select distinct id_subsistema, id_estado from {{ ref('stg_restricao_eolica') }}
    union
    select distinct id_subsistema, null as id_estado from {{ ref('stg_ena_diario_subsistema') }}
    union
    select distinct id_subsistema, null as id_estado from {{ ref('stg_cmo_semanal') }}
    union
    select distinct id_subsistema_origem as id_subsistema, null as id_estado from {{ ref('stg_intercambio_subsistema') }}
    union
    select distinct id_subsistema_destino as id_subsistema, null as id_estado from {{ ref('stg_intercambio_subsistema') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_subsistema', 'id_estado']) }} as id_localizacao,
    id_subsistema,
    coalesce(id_estado, 'N/A') as id_estado
from all_locations
where id_subsistema is not null
```

## dbt_projeto/models/marts/dimensions/dim_tempo.sql
```
-- models/marts/dimensions/dim_tempo.sql
with all_dates as (
    select distinct date_trunc('hour', instante_geracao) as horario from {{ ref('stg_geracao_usina') }}
    union
    select distinct date_trunc('hour', instante_medicao) from {{ ref('stg_fator_capacidade') }}
    union
    select distinct date_trunc('hour', instante_medicao) from {{ ref('stg_restricao_eolica') }}
    union
    select distinct date_trunc('hour', instante_medicao) from {{ ref('stg_intercambio_subsistema') }}
)
select
    horario as id_tempo,
    horario::date as data,
    extract(year from horario) as ano,
    extract(month from horario) as mes,
    extract(day from horario) as dia,
    extract(hour from horario) as hora,
    extract(dayofweek from horario) as dia_da_semana,
    extract(weekofyear from horario) as semana_do_ano,
    extract(quarter from horario) as trimestre
from all_dates
where horario is not null
```

## dbt_projeto/models/marts/dimensions/dim_usina.sql

```
-- models/marts/dimensions/dim_usina.sql
with all_usinas as (
    select id_ons, ceg, nom_usina, tipo_usina, tipo_combustivel
    from {{ ref('stg_geracao_usina') }}
    union
    select id_ons, ceg, nome_usina_conjunto as nom_usina, tipo_usina, null as tipo_combustivel
    from {{ ref('stg_fator_capacidade') }}
    union
    select id_ons, ceg, nom_usina, null as tipo_usina, null as tipo_combustivel
    from {{ ref('stg_restricao_eolica') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_ons', 'ceg', 'nom_usina']) }} as id_usina,
    id_ons,
    ceg,
    nom_usina,
    tipo_usina,
    tipo_combustivel
from all_usinas
where id_ons is not null and nom_usina is not null

```
## dbt_projeto/models/marts/facts/fct_geracao_energia.sql
```
-- models/marts/facts/fct_geracao_energia.sql
with geracao as (
    select
        instante_geracao as id_tempo,
        id_subsistema,
        id_estado,
        id_ons,
        ceg,
        nom_usina,
        geracao_mwmed
    from {{ ref('stg_geracao_usina') }}
),
capacidade as (
    select
        instante_medicao as id_tempo,
        id_ons,
        ceg,
        nome_usina_conjunto as nom_usina,
        capacidade_instalada_mw,
        fator_capacidade
    from {{ ref('stg_fator_capacidade') }}
),
restricao as (
    select
        instante_medicao as id_tempo,
        id_ons,
        ceg,
        nom_usina,
        geracao_estimada_mw as restricao_geracao_estimada_mw
    from {{ ref('stg_restricao_eolica') }}
),
ena as (
    select
        data_medicao,
        id_subsistema,
        ena_bruta_mwmed,
        ena_armazenavel_mwmed
    from {{ ref('stg_ena_diario_subsistema') }}
),
cmo as (
    select
        data_semana,
        id_subsistema,
        cmo_medio_semanal_rs_mwh
    from {{ ref('stg_cmo_semanal') }}
)
select
    -- Chaves
    ger.id_tempo,
    {{ dbt_utils.generate_surrogate_key(['ger.id_subsistema', 'ger.id_estado']) }} as id_localizacao,
    {{ dbt_utils.generate_surrogate_key(['ger.id_ons', 'ger.ceg', 'ger.nom_usina']) }} as id_usina,

    -- Métricas de Geração e Capacidade (horário)
    ger.geracao_mwmed,
    cap.capacidade_instalada_mw,
    cap.fator_capacidade,
    res.restricao_geracao_estimada_mw,

    -- Métricas de Energia e Custo (juntando com granularidade menor)
    ena.ena_bruta_mwmed,
    ena.ena_armazenavel_mwmed,
    cmo.cmo_medio_semanal_rs_mwh

from geracao ger
left join capacidade cap
    on ger.id_tempo = cap.id_tempo and ger.id_ons = cap.id_ons and ger.ceg = cap.ceg
left join restricao res
    on ger.id_tempo = res.id_tempo and ger.id_ons = res.id_ons and ger.ceg = res.ceg
left join ena
    on ger.id_tempo::date = ena.data_medicao and ger.id_subsistema = ena.id_subsistema
left join cmo
    on date_trunc('week', ger.id_tempo) = date_trunc('week', cmo.data_semana) and ger.id_subsistema = cmo.id_subsistema

```

## dbt_projeto/models/marts/facts/fct_intercambio_energetico.sql
```
-- models/marts/facts/fct_intercambio_energetico.sql
select
    -- Chaves
    inter.instante_medicao as id_tempo,
    loc_origem.id_localizacao as id_localizacao_origem,
    loc_destino.id_localizacao as id_localizacao_destino,

    -- Métrica
    inter.intercambio_mwmed

from {{ ref('stg_intercambio_subsistema') }} inter
left join {{ ref('dim_localizacao') }} loc_origem
    on inter.id_subsistema_origem = loc_origem.id_subsistema
left join {{ ref('dim_localizacao') }} loc_destino
    on inter.id_subsistema_destino = loc_destino.id_subsistema

```

## dbt_projeto/models/marts/facts/fct_confiabilidade_rede.sql
```
-- models/marts/facts/fct_confiabilidade_rede.sql
select
    {{ dbt_utils.generate_surrogate_key(['data_referencia', 'nome_agregacao']) }} as id_fato_confiabilidade,
    data_referencia,
    nome_agregacao,
    tipo_agregacao,
    periodicidade,
    num_linhas_operacao,
    num_linhas_violadas,
    indicador_ccal_percentual
from {{ ref('stg_ind_confiabilidade_ccal') }}

```


## Diagrama de Fluxo (Flowchart) - Arquitetura da Solução em Nuvem para o Projeto de Energia

```mermaid
graph TD
    subgraph Camada 1: Fontes de Dados
        A[Portal ONS] --> B{Arquivos CSV na AWS S3}
    end

    B -->|Ingestão de Dados  ELT| C[Airbyte]

    subgraph Camada 2:Ingestão de Dados_Extract & Load
        C --> D[ Carregamento no Snowflake]
    end

    subgraph Camada 3: Armazenamento e Transformação_Snowflake
        D --> E[Database: RAW_DATA]
        E --> F[dbt - Data Build Tool]
        F --> G{models/staging/}
        F --> H{models/marts/}
        G --> I[Database: ANALYTICS]
        H --> I
    end

    I -->|Extração Orquestrada| J[Apache Airflow]

    subgraph Camada 4: Orquestração e Execução_Airflow em Docker
        J --> K[DAG: dbt_etl_pipeline_ Executa dbt run/test]
        J --> L[DAG: export_fact_to_gcs]
    end

    K --> I
    L --> M[Consulta: fct_geracao_energia]
    M --> N[Exporta para CSV]

    N -->|Armazenamento de Artefato| O[Google Cloud Storage_ GCS]

    subgraph Camada 5: Camada de Saída_Output Layer
        O --> P{Bucket: projeto-etl-m2-fatos}
    end

    P -->|Leitura e Análise| Q[Google Colab]

    subgraph Camada 6: Análise e Consumo
        Q --> R[Análises Exploratórias]
        Q --> S[Treinamento de Modelos de ML]
    end
```
