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