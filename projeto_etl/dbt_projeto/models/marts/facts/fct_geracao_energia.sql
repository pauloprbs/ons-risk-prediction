with geracao as (
    select
        date_trunc('hour', instante_geracao) as id_tempo,
        id_subsistema,
        id_estado,
        id_ons,
        ceg,
        nom_usina,
        geracao_mwmed
    from {{ ref('stg_geracao_usina') }}
),

capacidade as (
    select
        date_trunc('hour', instante_medicao) as id_tempo,
        id_subsistema,
        id_estado,
        id_ons,
        ceg,
        nome_usina_conjunto as nom_usina,
        capacidade_instalada_mw,
        geracao_verificada_mwmed,
        fator_capacidade
    from {{ ref('stg_fator_capacidade') }}
),

dim_localizacao as (
    select * from {{ ref('dim_localizacao') }}
),

dim_usina as (
    select * from {{ ref('dim_usina') }}
)

select
    ger.id_tempo,
    loc.id_localizacao,
    usr.id_usina,
    ger.geracao_mwmed,
    cap.capacidade_instalada_mw,
    cap.geracao_verificada_mwmed,
    cap.fator_capacidade
from geracao ger
left join capacidade cap
    on ger.id_tempo = cap.id_tempo
    and ger.id_ons = cap.id_ons
    and ger.ceg = cap.ceg
left join dim_localizacao loc
    on ger.id_subsistema = loc.id_subsistema
    and ger.id_estado = loc.id_estado
left join dim_usina usr
    on ger.id_ons = usr.id_ons
    and ger.ceg = usr.ceg
    and ger.nom_usina = usr.nom_usina
