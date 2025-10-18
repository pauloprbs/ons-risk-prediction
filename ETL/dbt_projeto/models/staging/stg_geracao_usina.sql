select
    "DIN_INSTANTE"::timestamp as instante_geracao,
    "ID_SUBSISTEMA" as id_subsistema,
    "ID_ESTADO" as id_estado,
    "ID_ONS" as id_ons,
    "CEG" as ceg,
    "NOM_TIPOUSINA" as tipo_usina,
    "NOM_TIPOCOMBUSTIVEL" as tipo_combustivel,
    "NOM_USINA" as nom_usina,
    "VAL_GERACAO" as geracao_mwmed
from {{ source('BR_ENERGY_DATA', 'GERACAO_USINA') }}
