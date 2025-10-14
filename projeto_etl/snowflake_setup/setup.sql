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
