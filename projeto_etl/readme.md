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

## Fator de capacidade</h3>
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

## Estrutura da pasta:
```
projeto_etl/
├── docker-compose.yml
├── airflow/
│   └── keys/
│   └── dags/
│       └── dbt_etl_dag.py
│       └── export_fact_to_gcs_dag.py
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
    │   └── marts/
    │       ├── dimensions/
    │       │   ├── dim_localizacao.sql
    │       │   ├── dim_tempo.sql
    │       │   └── dim_usina.sql
    │       └── facts/
    │           └── fct_geracao_energia.sql
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

## models/sources.ym
```
# projeto_etl/dbt_projeto/models/staging/sources.yml
version: 2

sources:
  - name: BR_ENERGY_DATA
    database: "{{ var('raw_database', 'RAW_DATA') }}"
    schema: "{{ var('raw_schema', 'BR_ENERGY_DATA') }}"
    tables:
      - name: GERACAO_USINA
      - name: FATOR_CAPACIDADE
      - name: EAR_DIARIO_SUBSISTEMA
      - name: INTERRUPCAO_CARGA
      - name: STG_EAR_DIARIO
```

## dbt_projeto/packages.yml
```
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
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

## dbt_projeto/models/marts/dimensions/dim_localizacao.sql
```
with all_locations as (
    select distinct
        id_subsistema,
        id_estado
    from {{ ref('stg_geracao_usina') }}
    union
    select distinct
        id_subsistema,
        id_estado
    from {{ ref('stg_fator_capacidade') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_subsistema', 'id_estado']) }} as id_localizacao,
    id_subsistema,
    id_estado
from all_locations
```

## dbt_projeto/models/marts/dimensions/dim_tempo.sql
```
with all_dates as (
    select distinct date_trunc('hour', instante_geracao) as horario from {{ ref('stg_geracao_usina') }}
    union
    select distinct date_trunc('hour', instante_medicao) as horario from {{ ref('stg_fator_capacidade') }}
)
select
    horario as id_tempo,
    extract(year from horario) as ano,
    extract(month from horario) as mes,
    extract(day from horario) as dia,
    extract(hour from horario) as hora,
    extract(dayofweek from horario) as dia_da_semana,
    extract(quarter from horario) as trimestre
from all_dates

```

## dbt_projeto/models/marts/dimensions/dim_usina.sql

```
with all_usinas as (
    select
        id_ons,
        ceg,
        nom_usina,
        tipo_usina,
        tipo_combustivel
    from {{ ref('stg_geracao_usina') }}
    union
    select
        id_ons,
        ceg,
        nome_usina_conjunto as nom_usina,
        tipo_usina,
        null as tipo_combustivel -- FatorCapacidade não tem combustível
    from {{ ref('stg_fator_capacidade') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_ons', 'ceg', 'nom_usina']) }} as id_usina,
    id_ons,
    ceg,
    nom_usina,
    tipo_usina,
    tipo_combustivel
from all_usinas

```
## dbt_projeto/models/marts/facts/fct_geracao_energia.sql
```
with geracao as (
    select
        date_trunc('hour', instante_geracao) as id_tempo,
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
        date_trunc('hour', instante_medicao) as id_tempo,
        id_subsistema,
        id_estado,
        id_ons,
        ceg,
        nome_usina_conjunto as nom_usina,
        capacidade_instalada_mw,
        geracao_verificada_mwmed,
        fator_capacidade
    from {{ ref('stg_fator_capacidade') }}
),

dim_localizacao as (
    select * from {{ ref('dim_localizacao') }}
),

dim_usina as (
    select * from {{ ref('dim_usina') }}
)

select
    ger.id_tempo,
    loc.id_localizacao,
    usr.id_usina,
    ger.geracao_mwmed,
    cap.capacidade_instalada_mw,
    cap.geracao_verificada_mwmed,
    cap.fator_capacidade
from geracao ger
left join capacidade cap
    on ger.id_tempo = cap.id_tempo
    and ger.id_ons = cap.id_ons
    and ger.ceg = cap.ceg
left join dim_localizacao loc
    on ger.id_subsistema = loc.id_subsistema
    and ger.id_estado = loc.id_estado
left join dim_usina usr
    on ger.id_ons = usr.id_ons
    and ger.ceg = usr.ceg
    and ger.nom_usina = usr.nom_usina
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



