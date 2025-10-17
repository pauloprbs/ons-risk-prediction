-- ====================================================================
-- SCRIPT 02: CRIAÇÃO DE TODAS AS TABELAS NA CAMADA RAW (VERSÃO CORRIGIDA)
-- Propósito: Definir o schema de todas as tabelas que receberão os dados brutos.
-- Execução: Execute este script para criar (ou recriar) a estrutura das tabelas vazias.
-- ====================================================================

USE WAREHOUSE DBT_WH;
USE DATABASE RAW_DB;
USE SCHEMA ONS_DATA;

-- Tabela para Interrupção de Carga (CSV)
CREATE OR REPLACE TABLE INTERRUPCAO_CARGA_RAW (cod_perturbacao VARCHAR, din_interrupcaocarga VARCHAR, id_subsistema VARCHAR, nom_subsistema VARCHAR, id_estado VARCHAR, nom_agente VARCHAR, val_cargainterrompida_mw VARCHAR, val_tempomedio_minutos VARCHAR, val_energianaosuprida_mwh VARCHAR, flg_envolveuredebasica VARCHAR, flg_envolveuredeoperacao VARCHAR);

-- Tabelas de Carga (Parquet)
CREATE OR REPLACE TABLE CARGA_VERIFICADA_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, id_estado VARCHAR, nom_estado VARCHAR, id_areacarga VARCHAR, nom_areacarga VARCHAR, din_referenciautc TIMESTAMP_NTZ, val_cargaglobal FLOAT);
CREATE OR REPLACE TABLE CARGA_PROGRAMADA_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, id_areacarga VARCHAR, nom_areacarga VARCHAR, din_referenciautc TIMESTAMP_NTZ, val_cargaglobalprogramada FLOAT);

-- Tabela para Geração de Usina (CSV)
CREATE OR REPLACE TABLE GERACAO_USINA_RAW (din_instante VARCHAR, id_subsistema VARCHAR, nom_subsistema VARCHAR, id_estado VARCHAR, nom_estado VARCHAR, cod_modalidadeoperacao VARCHAR, nom_tipousina VARCHAR, nom_tipocombustivel VARCHAR, nom_usina VARCHAR, id_ons VARCHAR, ceg VARCHAR, val_geracao VARCHAR);

-- Tabelas para Restrição de Rede (CSV)
CREATE OR REPLACE TABLE RESTRICAO_EOLICA_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, id_estado VARCHAR, nom_estado VARCHAR, nom_usina VARCHAR, id_ons VARCHAR, ceg VARCHAR, din_instante VARCHAR, val_geracao VARCHAR, val_geracaolimitada VARCHAR, val_disponibilidade VARCHAR, val_geracaoreferencia VARCHAR, val_geracaoreferenciafinal VARCHAR, cod_razaorestricao VARCHAR, cod_origemrestricao VARCHAR, dsc_restricao VARCHAR);
CREATE OR REPLACE TABLE RESTRICAO_FOTOVOLTAICA_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, id_estado VARCHAR, nom_estado VARCHAR, nom_usina VARCHAR, id_ons VARCHAR, ceg VARCHAR, din_instante VARCHAR, val_geracao VARCHAR, val_geracaolimitada VARCHAR, val_disponibilidade VARCHAR, val_geracaoreferencia VARCHAR, val_geracaoreferenciafinal VARCHAR, cod_razaorestricao VARCHAR, cod_origemrestricao VARCHAR, dsc_restricao VARCHAR);

-- Tabela para Intercâmbio Nacional (CSV)
CREATE OR REPLACE TABLE INTERCAMBIO_NACIONAL_RAW (din_instante VARCHAR, id_subsistema_origem VARCHAR, nom_subsistema_origem VARCHAR, id_subsistema_destino VARCHAR, nom_subsistema_destino VARCHAR, val_intercambiomwmed VARCHAR);

-- Tabelas Hídricas (CSV)
-- CORREÇÃO: A tabela ENA agora tem 7 colunas para corresponder ao arquivo de origem.
CREATE OR REPLACE TABLE EAR_DIARIO_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, ear_data VARCHAR, ear_max_subsistema VARCHAR, ear_verif_subsistema_mwmes VARCHAR, ear_verif_subsistema_percentual VARCHAR);
CREATE OR REPLACE TABLE ENA_DIARIO_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, id_bacia VARCHAR, nom_bacia VARCHAR, ena_data VARCHAR, ena_bruta_verif_mwmed VARCHAR, ena_bruta_regiao_percentualmlt VARCHAR);

-- Tabelas Adicionais (CSV)
-- CORREÇÃO: A tabela CMO agora tem 7 colunas para corresponder ao arquivo de origem.
CREATE OR REPLACE TABLE CMO_SEMANAL_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, din_instante VARCHAR, val_cmopesado VARCHAR, val_cmoleve VARCHAR, val_cmomedio VARCHAR, val_cmomediasemanal VARCHAR);
CREATE OR REPLACE TABLE DISPONIBILIDADE_USINA_RAW (id_subsistema VARCHAR, nom_subsistema VARCHAR, id_estado VARCHAR, nom_estado VARCHAR, nom_usina VARCHAR, id_tipousina VARCHAR, nom_tipocombustivel VARCHAR, id_ons VARCHAR, ceg VARCHAR, din_instante VARCHAR, val_potenciainstalada VARCHAR, val_dispoperacional VARCHAR, val_dispsincronizada VARCHAR);

-- Tabela para Clima (CSV)
CREATE OR REPLACE TABLE CLIMA_GO_DIARIO_RAW ("data" VARCHAR, ghi VARCHAR, temp2m_c VARCHAR, precipitacao_mm VARCHAR);