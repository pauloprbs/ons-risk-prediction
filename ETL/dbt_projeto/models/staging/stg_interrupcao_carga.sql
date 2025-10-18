-- local:  models/staging/stg_interrupcao_carga.sql

select
    "COD_PERTURBACAO" as id_perturbacao, -- Identificador da perturbação no Sistema Integrado de Perturbações
    "DIN_INTERRUPCAOCARGA" as instante_interrupcao, -- Instante da interrupção de carga
    "ID_SUBSISTEMA" as id_subsistema, -- Sigla do subsistema
    "NOM_SUBSISTEMA" as nom_subsistema, -- Nome do subsistema
    "ID_ESTADO" as id_estado, -- Sigla do estado
    "NOM_AGENTE" as nom_agente, -- Nome do agente afetado pela interrupção de carga
    "VAL_CARGAINTERROMPIDA_MW" as carga_interrompida_mw, -- Valor da interrupção de carga, em MW
    "VAL_TEMPOMEDIO_MINUTOS" as tempo_recomposicao_minutos, -- Tempo médio para recompor a carga, em minutos
    "VAL_ENERGIANAOSUPRIDA_MWH" as energia_nao_suprida_mwh, -- Valor da energia não suprida na perturbação, em MWh
    
    -- Converte S/N para True/False para facilitar a análise
    ("FLG_ENVOLVEUREDEBASICA" = 'S') as envolveu_rede_basica, -- Indica se houve envolvimento de equipamentos da Rede Básica na perturbação
    ("FLG_ENVOLVEUREDEOPERACAO" = 'S') as envolveu_rede_operacao -- Indica se houve envolvimento de equipamentos da Rede de Operação do ONS na perturbação

from {{ source('BR_ENERGY_DATA', 'INTERRUPCAO_CARGA') }}
