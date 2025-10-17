-- ====================================================================
-- SCRIPT 01: CONFIGURAÇÃO INICIAL DO AMBIENTE SNOWFLAKE
-- Propósito: Criar os bancos de dados, schemas, warehouse, formatos de arquivo e o stage.
-- Execução: Execute este script uma única vez para preparar o ambiente.
-- ====================================================================

-- Use uma role com permissões para criar bancos de dados
USE ROLE SYSADMIN;

-- CRIAÇÃO DE BANCOS DE DADOS E SCHEMAS
CREATE DATABASE IF NOT EXISTS RAW_DB COMMENT = 'Banco de dados para dados brutos, cópia fiel das fontes.';
CREATE SCHEMA IF NOT EXISTS RAW_DB.ONS_DATA;

CREATE DATABASE IF NOT EXISTS STAGING_DB COMMENT = 'Banco de dados para dados limpos e transformações intermediárias.';
CREATE SCHEMA IF NOT EXISTS STAGING_DB.STG_ONS;

CREATE DATABASE IF NOT EXISTS CORE_DB COMMENT = 'Banco de dados para tabelas finais e prontas para consumo (analytics, ML).';
CREATE SCHEMA IF NOT EXISTS CORE_DB.ML_FEATURES;

-- CRIAÇÃO DO WAREHOUSE DE COMPUTAÇÃO
CREATE WAREHOUSE IF NOT EXISTS DBT_WH 
    WITH WAREHOUSE_SIZE = 'X-SMALL' AUTO_SUSPEND = 60 COMMENT = 'Warehouse dedicado para as transformações do dbt e cargas.';

-- MUDANÇA DE CONTEXTO PARA CONFIGURAR OBJETOS
USE DATABASE RAW_DB;
USE SCHEMA ONS_DATA;

-- CRIAÇÃO DOS FORMATOS DE ARQUIVO
-- Formato para arquivos CSV com delimitador ';'
CREATE OR REPLACE FILE FORMAT ONS_CSV_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = ';'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    EMPTY_FIELD_AS_NULL = TRUE
    COMMENT = 'Formato padrão para arquivos CSV da ONS com delimitador ponto-e-vírgula.';

-- Formato para arquivos Parquet
CREATE OR REPLACE FILE FORMAT ONS_PARQUET_FORMAT
    TYPE = 'PARQUET'
    COMMENT = 'Formato padrão para arquivos Parquet, como os da API de Carga.';

-- CRIAÇÃO DO STAGE INTERNO
-- NOTA: A ausência da palavra 'TEMPORARY' garante que o stage seja PERMANENT (padrão do Snowflake).
-- Os arquivos permanecerão aqui até serem removidos manualmente.
CREATE OR REPLACE STAGE ONS_RAW_STAGE
    COMMENT = 'Stage interno e permanente para upload dos arquivos brutos do projeto ONS.';