select
    "DIN_INSTANTE"::timestamp as instante_medicao,
    "ID_SUBSISTEMA" as id_subsistema,
    "ID_ESTADO" as id_estado,
    "ID_ONS" as id_ons,
    "CEG" as ceg,
    "NOM_TIPOUSINA" as tipo_usina,
    "NOM_USINA_CONJUNTO" as nome_usina_conjunto,
    "VAL_CAPACIDADEINSTALADA" as capacidade_instalada_mw,
    "VAL_GERACAOVERIFICADA" as geracao_verificada_mwmed,
    "VAL_FATORCAPACIDADE" as fator_capacidade
from {{ source('BR_ENERGY_DATA', 'FATOR_CAPACIDADE') }}
