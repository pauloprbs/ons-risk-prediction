-- models/marts/facts/fct_geracao_energia.sql
with geracao as (
    select
        instante_geracao as id_tempo,
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
        instante_medicao as id_tempo,
        id_ons,
        ceg,
        nome_usina_conjunto as nom_usina,
        capacidade_instalada_mw,
        fator_capacidade
    from {{ ref('stg_fator_capacidade') }}
),
restricao as (
    select
        instante_medicao as id_tempo,
        id_ons,
        ceg,
        nom_usina,
        geracao_estimada_mw as restricao_geracao_estimada_mw
    from {{ ref('stg_restricao_eolica') }}
),
ena as (
    select
        data_medicao,
        id_subsistema,
        ena_bruta_mwmed,
        ena_armazenavel_mwmed
    from {{ ref('stg_ena_diario_subsistema') }}
),
cmo as (
    select
        data_semana,
        id_subsistema,
        cmo_medio_semanal_rs_mwh
    from {{ ref('stg_cmo_semanal') }}
)
select
    -- Chaves
    ger.id_tempo,
    {{ dbt_utils.generate_surrogate_key(['ger.id_subsistema', 'ger.id_estado']) }} as id_localizacao,
    {{ dbt_utils.generate_surrogate_key(['ger.id_ons', 'ger.ceg', 'ger.nom_usina']) }} as id_usina,

    -- Métricas de Geração e Capacidade (horário)
    ger.geracao_mwmed,
    cap.capacidade_instalada_mw,
    cap.fator_capacidade,
    res.restricao_geracao_estimada_mw,

    -- Métricas de Energia e Custo (juntando com granularidade menor)
    ena.ena_bruta_mwmed,
    ena.ena_armazenavel_mwmed,
    cmo.cmo_medio_semanal_rs_mwh

from geracao ger
left join capacidade cap
    on ger.id_tempo = cap.id_tempo and ger.id_ons = cap.id_ons and ger.ceg = cap.ceg
left join restricao res
    on ger.id_tempo = res.id_tempo and ger.id_ons = res.id_ons and ger.ceg = res.ceg
left join ena
    on ger.id_tempo::date = ena.data_medicao and ger.id_subsistema = ena.id_subsistema
left join cmo
    on date_trunc('week', ger.id_tempo) = date_trunc('week', cmo.data_semana) and ger.id_subsistema = cmo.id_subsistema