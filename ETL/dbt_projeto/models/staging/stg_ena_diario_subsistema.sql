-- models/staging/stg_ena_diario_subsistema.sql
select
    "ENA_DATA"::date as data_medicao,
    "ID_SUBSISTEMA" as id_subsistema,
    "NOM_SUBSISTEMA" as nom_subsistema,
    "ENA_BRUTA_REGIAO_MWMED" as ena_bruta_mwmed,
    "ENA_ARMAZENAVEL_REGIAO_MWMED" as ena_armazenavel_mwmed
from {{ source('BR_ENERGY_DATA', 'ENA_DIARIO_SUBSISTEMA') }}