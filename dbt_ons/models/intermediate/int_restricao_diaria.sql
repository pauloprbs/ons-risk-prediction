-- models/intermediate/int_restricao_diaria.sql
-- Une as fontes de restrição e calcula o total diário de MWh restrito

with stg_restricao_eolica as (
    select 
        timestamp_restricao, 
        (geracao_referencia_mwh - geracao_mwh) as mwh_restrito
    from {{ ref('stg_restricao_eolica') }}
),

stg_restricao_fotovoltaica as (
    select 
        timestamp_restricao, 
        (geracao_referencia_mwh - geracao_mwh) as mwh_restrito
    from {{ ref('stg_restricao_fotovoltaica') }}
),

restricao_unificada as (
    select * from stg_restricao_eolica
    union all
    select * from stg_restricao_fotovoltaica
)

select
    date_trunc('DAY', timestamp_restricao) as dia,
    sum(mwh_restrito) as total_mwh_restrito_go
from restricao_unificada
group by 1