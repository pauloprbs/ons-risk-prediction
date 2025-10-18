-- local: models/staging/stg_ear_diario.sql

select
    "ID_SUBSISTEMA" as id_subsistema, -- Código do Subsistema 
    "NOM_SUBSISTEMA" as nom_subsistema, -- Nome da Subsistema 
--   "EAR_DATA" as ear_data as data_medicao, -- Dia observado da medida
	"EAR_DATA" as data_medicao, -- Dia observado da medida
    "EAR_MAX_SUBSISTEMA" as ear_maxima_mwmes, -- Valor de EAR máxima por subsistema na unidade de medida MWmês
    "EAR_VERIF_SUBSISTEMA_MWMES" as ear_verificada_mwmes, -- Valor de EAR verificada no dia por subsistema na unidade de medida MWmês
    "EAR_VERIF_SUBSISTEMA_PERCENTUAL"  as ear_verificada_percentual -- Valor de EAR verificada no dia por subsistema na unidade de medida % 

from {{ source('BR_ENERGY_DATA', 'EAR_DIARIO_SUBSISTEMA') }}

