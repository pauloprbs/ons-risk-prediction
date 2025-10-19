-- ====================================================================
-- CORREÇÃO DA TABELA ENA_DIARIO_RAW
-- Execute este script para corrigir a estrutura e recarregar os dados
-- ====================================================================

USE WAREHOUSE DBT_WH;
USE DATABASE RAW_DB;
USE SCHEMA ONS_DATA;

-- Recriar a tabela com a estrutura CORRETA (5 colunas, não 7)
CREATE OR REPLACE TABLE ENA_DIARIO_RAW (
    id_subsistema VARCHAR,
    nom_subsistema VARCHAR,
    ena_data VARCHAR,  -- Será convertido para DATE no staging
    ena_bruta_regiao_mwmed VARCHAR,
    ena_bruta_regiao_percentualmlt VARCHAR,
    ena_armazenavel_regiao_mwmed VARCHAR,
    ena_armazenavel_regiao_percentualmlt VARCHAR
);

-- Recarregar os dados
COPY INTO ENA_DIARIO_RAW 
FROM @ONS_RAW_STAGE/ena_diario/ 
FILE_FORMAT = (FORMAT_NAME = 'ONS_CSV_FORMAT') 
PURGE = FALSE 
ON_ERROR = 'CONTINUE';

-- Verificar os dados
SELECT * FROM ENA_DIARIO_RAW LIMIT 10;

-- Verificar se as datas estão corretas agora
SELECT 
    ena_data,
    TO_DATE(ena_data) as data_convertida,
    nom_subsistema
FROM ENA_DIARIO_RAW 
WHERE nom_subsistema = 'SUDESTE'
LIMIT 5;