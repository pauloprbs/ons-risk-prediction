-- models/core/fct_modeling_table_final.sql
-- Propósito: Criar a tabela larga final para modelagem,
-- unindo todas as fontes intermediárias e aplicando features de janela.

-- CTE 1: Reúne todas as fontes de dados diários
with all_data_joined as (
    select
        d.timestamp,
        
        -- Colunas de déficit
        d.deficit_diario_mwh,
        d.nivel_risco,
        
        -- Colunas de carga
        c.programada,
        c.verificada,
        c.diferenca_verif_prog,
        
        -- Colunas de geração
        g.geracao_total_diaria_go,
        g.geracao_eolieletrica_diaria,
        g.geracao_fotovoltaica_diaria,
        g.geracao_hidroeletrica_diaria,
        g.geracao_nuclear_diaria,
        g.geracao_termica_diaria,
        
        -- Coluna de restrição
        r.total_mwh_restrito_go,
        
        -- Coluna de intercâmbio
        i.saldo_intercambio_seco,
        
        -- Colunas hídricas
        h.ear_percentual_seco,
        h.ena_percentual_mlt_seco,
        
        -- Colunas adicionais
        a.disponibilidade_total_diaria_go,
        a.cmo_semanal_seco,

        -- Colunas de clima
        cl.ghi_kwh_m2_dia,
        cl.temp_media_c,
        cl.precipitacao_mm
        
    from {{ ref('int_deficit_diario') }} d
    left join {{ ref('int_carga_diaria') }} c 
        on d.timestamp::date = c.timestamp::date
    left join {{ ref('int_intercambio_diario') }} i 
        on d.timestamp::date = i.timestamp::date
    left join {{ ref('int_hidrica_diaria') }} h 
        on d.timestamp::date = h.timestamp::date
    left join {{ ref('int_adicionais_diario') }} a 
        on d.timestamp::date = a.timestamp::date
    left join {{ ref('int_clima_diario') }} cl 
        on d.timestamp::date = cl.timestamp::date
    left join {{ ref('int_geracao_diaria') }} g 
        on d.timestamp::date = g.dia::date
    left join {{ ref('int_restricao_diaria') }} r 
        on d.timestamp::date = r.dia::date
),

-- CTE 2: Aplica as features de janela (Window Functions)
final_features as (
    select
        *,
        
        -- Features de Carga (Notebook 06)
        avg(verificada) over (order by timestamp rows between 6 preceding and current row) as carga_media_7d,
        stddev(verificada) over (order by timestamp rows between 6 preceding and current row) as carga_std_7d,

        -- Features Hídricas (Notebook 06)
        lag(ear_percentual_seco, 1) over (order by timestamp) as ear_ontem,
        ear_percentual_seco - lag(ear_percentual_seco, 3) over (order by timestamp) as ear_diff_3d,

        -- Features de Interação (Notebook 06)
        (geracao_total_diaria_go - verificada) as margem_oferta_demanda,
        (verificada / nullif(ear_percentual_seco, 0)) as pressao_demanda_ear,
        
        -- Features Meteorológicas (Notebook 08)
        sum(precipitacao_mm) over (order by timestamp rows between 13 preceding and current row) as precip_acumulada_14d,
        sum(precipitacao_mm) over (order by timestamp rows between 29 preceding and current row) as precip_acumulada_30d
        
    from all_data_joined
)

-- Seleção final
select *
from final_features
where precip_acumulada_30d is not null
order by timestamp