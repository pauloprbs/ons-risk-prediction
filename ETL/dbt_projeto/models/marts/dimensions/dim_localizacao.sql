-- models/marts/dimensions/dim_localizacao.sql
with all_locations as (
    select distinct id_subsistema, id_estado from {{ ref('stg_geracao_usina') }}
    union
    select distinct id_subsistema, id_estado from {{ ref('stg_fator_capacidade') }}
    union
    select distinct id_subsistema, id_estado from {{ ref('stg_restricao_eolica') }}
    union
    select distinct id_subsistema, null as id_estado from {{ ref('stg_ena_diario_subsistema') }}
    union
    select distinct id_subsistema, null as id_estado from {{ ref('stg_cmo_semanal') }}
    union
    select distinct id_subsistema_origem as id_subsistema, null as id_estado from {{ ref('stg_intercambio_subsistema') }}
    union
    select distinct id_subsistema_destino as id_subsistema, null as id_estado from {{ ref('stg_intercambio_subsistema') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_subsistema', 'id_estado']) }} as id_localizacao,
    id_subsistema,
    coalesce(id_estado, 'N/A') as id_estado
from all_locations
where id_subsistema is not null