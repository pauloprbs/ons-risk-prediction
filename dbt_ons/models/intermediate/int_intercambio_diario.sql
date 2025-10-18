-- models/intermediate/int_intercambio_diario.sql
-- Calcula o saldo diário de intercâmbio para o subsistema Sudeste

with stg_intercambio as (
    select * from {{ ref('stg_intercambio_nacional') }}
),

entradas_diarias as (
    select
        date_trunc('DAY', timestamp_intercambio) as dia,
        sum(intercambio_mwh) as total_entradas_mwh
    from stg_intercambio
    where subsistema_destino = 'SUDESTE'
    group by 1
),

saidas_diarias as (
    select
        date_trunc('DAY', timestamp_intercambio) as dia,
        sum(intercambio_mwh) as total_saidas_mwh
    from stg_intercambio
    where subsistema_origem = 'SUDESTE'
    group by 1
)

select
    d.date_day as timestamp, -- <-- CORRIGIDO AQUI
    coalesce(e.total_entradas_mwh, 0) as entradas_seco_mwh,
    coalesce(s.total_saidas_mwh, 0) as saidas_seco_mwh,
    (coalesce(e.total_entradas_mwh, 0) - coalesce(s.total_saidas_mwh, 0)) as saldo_intercambio_seco
    
from {{ ref('int_all_days') }} d
left join entradas_diarias e on d.date_day = e.dia -- <-- CORRIGIDO AQUI
left join saidas_diarias s on d.date_day = s.dia -- <-- CORRIGIDO AQUI