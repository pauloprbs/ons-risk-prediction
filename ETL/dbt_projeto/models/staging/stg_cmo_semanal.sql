-- models/staging/stg_cmo_semanal.sql
select
    "DIN_INSTANTE"::date as data_semana,
    "ID_SUBSISTEMA" as id_subsistema,
    "VAL_CMOMEDIASEMANAL" as cmo_medio_semanal_rs_mwh,
    "VAL_CMOLEVE" as cmo_patamar_leve_rs_mwh,
    "VAL_CMOMEDIA" as cmo_patamar_medio_rs_mwh,
    "VAL_CMOPESADA" as cmo_patamar_pesado_rs_mwh
from {{ source('BR_ENERGY_DATA', 'CMO_SEMANAL') }}