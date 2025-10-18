-- models/staging/stg_restricao_eolica.sql
select
    "DIN_INSTANTE"::timestamp as instante_medicao,
    "ID_SUBSISTEMA" as id_subsistema,
    "ID_ESTADO" as id_estado,
    "ID_ONS" as id_ons,
    "CEG" as ceg,
    "NOM_USINA" as nom_usina,
    "VAL_GERACAOESTIMADA" as geracao_estimada_mw,
    "VAL_GERACAOVERIFICADA" as geracao_verificada_mw
from {{ source('BR_ENERGY_DATA', 'RESTRICAO_EOLICA') }}