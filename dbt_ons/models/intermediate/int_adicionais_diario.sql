-- models/intermediate/int_adicionais_diario.sql
-- Agrega Disponibilidade por dia e faz o 'forward fill' do CMO semanal

with disponibilidade_diaria as (
    select
        date_trunc('DAY', timestamp_ocorrencia) as dia,
        sum(disponibilidade_operacional_mwh) as disponibilidade_total_diaria_go
    from {{ ref('stg_disponibilidade_usina') }}
    group by 1
),

cmo_semanal as (
    select
        date_trunc('DAY', timestamp_semana) as dia_semana,
        cmo_medio_semanal
    from {{ ref('stg_cmo_semanal') }}
),

cmo_diario as (
    -- Preenche os valores de CMO para todos os dias da semana
    select
        d.date_day as dia, -- <-- CORRIGIDO AQUI
        -- Pega o último valor não nulo de CMO, ordenado por dia
        last_value(c.cmo_medio_semanal ignore nulls) over (order by d.date_day) as cmo_semanal_seco -- <-- CORRIGIDO AQUI
    from {{ ref('int_all_days') }} d
    left join cmo_semanal c on d.date_day = c.dia_semana -- <-- CORRIGIDO AQUI
)

select
    d.date_day as timestamp, -- <-- CORRIGIDO AQUI
    coalesce(disp.disponibilidade_total_diaria_go, 0) as disponibilidade_total_diaria_go,
    cmo.cmo_semanal_seco
    
from {{ ref('int_all_days') }} d
left join disponibilidade_diaria disp on d.date_day = disp.dia -- <-- CORRIGIDO AQUI
left join cmo_diario cmo on d.date_day = cmo.dia -- <-- CORRIGIDO AQUI