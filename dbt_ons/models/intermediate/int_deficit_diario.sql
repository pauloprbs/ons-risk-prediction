-- models/intermediate/int_deficit_diario.sql
-- Propósito: Agregar a energia não suprida por dia e definir a variável alvo 'nivel_risco'.

-- Define os limiares de quantil da sua análise
{% set limite_alto = 18.31 %}
{% set limite_medio = 4.20 %}

-- CTE 1: Pega a espinha dorsal de datas do nosso novo modelo
with all_days as (
    -- Este modelo (int_all_days) cria uma coluna chamada 'date_day'
    select * from {{ ref('int_all_days') }}
),

-- CTE 2: Pega os dados de staging de interrupção
stg_interrupcao as (
    select * from {{ ref('stg_interrupcao_carga') }}
),

-- CTE 3: Agrega o déficit por dia
daily_deficit as (
    select
        date_trunc('DAY', timestamp_interrupcao) as dia,
        sum(energia_nao_suprida_mwh) as deficit_diario_mwh
    from stg_interrupcao
    group by 1
)

-- Final Select: Junta a espinha dorsal de datas (all_days) com os déficits
select
    ad.date_day as timestamp, 
    coalesce(dd.deficit_diario_mwh, 0) as deficit_diario_mwh,
    
    -- Aplica a lógica de classificação de risco
    case
        when coalesce(dd.deficit_diario_mwh, 0) >= {{ limite_alto }} then 'alto'
        when coalesce(dd.deficit_diario_mwh, 0) >= {{ limite_medio }} then 'medio'
        else 'baixo'
    end as nivel_risco

from all_days ad
-- CORREÇÃO: Usar 'ad.date_day' no join
left join daily_deficit dd on ad.date_day = dd.dia