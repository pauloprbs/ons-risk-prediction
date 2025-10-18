-- models/staging/stg_intercambio_subsistema.sql
select
    "DIN_INSTANTE"::timestamp as instante_medicao,
    "ID_SUBSISTEMA_ORIGEM" as id_subsistema_origem,
    "ID_SUBSISTEMA_DESTINO" as id_subsistema_destino,
    "VAL_INTERCAMBIOMWMED" as intercambio_mwmed
from {{ source('BR_ENERGY_DATA', 'INTERCAMBIO_SUBSISTEMA') }}