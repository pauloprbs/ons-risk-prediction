-- models/intermediate/int_carga_diaria.sql
-- Agrega a carga programada e verificada por dia

with stg_carga_programada as (
    select
        date_trunc('DAY', timestamp_referencia) as dia,
        sum(carga_programada_mwh) as programada
    from {{ ref('stg_carga_programada') }}
    group by 1
),

stg_carga_verificada as (
    select
        date_trunc('DAY', timestamp_referencia) as dia,
        sum(carga_verificada_mwh) as verificada
    from {{ ref('stg_carga_verificada') }}
    group by 1
)

select
    d.date_day as timestamp,
    coalesce(p.programada, 0) as programada,
    coalesce(v.verificada, 0) as verificada,
    (coalesce(v.verificada, 0) - coalesce(p.programada, 0)) as diferenca_verif_prog

from {{ ref('int_all_days') }} d
left join stg_carga_programada p on d.date_day = p.dia
left join stg_carga_verificada v on d.date_day = v.dia