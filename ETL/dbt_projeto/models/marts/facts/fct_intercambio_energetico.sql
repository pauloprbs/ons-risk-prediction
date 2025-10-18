-- models/marts/facts/fct_intercambio_energetico.sql
select
    -- Chaves
    inter.instante_medicao as id_tempo,
    loc_origem.id_localizacao as id_localizacao_origem,
    loc_destino.id_localizacao as id_localizacao_destino,

    -- Métrica
    inter.intercambio_mwmed

from {{ ref('stg_intercambio_subsistema') }} inter
left join {{ ref('dim_localizacao') }} loc_origem
    on inter.id_subsistema_origem = loc_origem.id_subsistema
left join {{ ref('dim_localizacao') }} loc_destino
    on inter.id_subsistema_destino = loc_destino.id_subsistema