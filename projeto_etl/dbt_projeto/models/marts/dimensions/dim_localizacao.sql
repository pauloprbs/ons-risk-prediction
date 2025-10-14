with all_locations as (
    select distinct
        id_subsistema,
        id_estado
    from {{ ref('stg_geracao_usina') }}
    union
    select distinct
        id_subsistema,
        id_estado
    from {{ ref('stg_fator_capacidade') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_subsistema', 'id_estado']) }} as id_localizacao,
    id_subsistema,
    id_estado
from all_locations
