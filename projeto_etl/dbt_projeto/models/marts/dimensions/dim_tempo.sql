with all_dates as (
    select distinct date_trunc('hour', instante_geracao) as horario from {{ ref('stg_geracao_usina') }}
    union
    select distinct date_trunc('hour', instante_medicao) as horario from {{ ref('stg_fator_capacidade') }}
)
select
    horario as id_tempo,
    extract(year from horario) as ano,
    extract(month from horario) as mes,
    extract(day from horario) as dia,
    extract(hour from horario) as hora,
    extract(dayofweek from horario) as dia_da_semana,
    extract(quarter from horario) as trimestre
from all_dates
