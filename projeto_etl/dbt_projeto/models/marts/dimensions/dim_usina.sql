with all_usinas as (
    select
        id_ons,
        ceg,
        nom_usina,
        tipo_usina,
        tipo_combustivel
    from {{ ref('stg_geracao_usina') }}
    union
    select
        id_ons,
        ceg,
        nome_usina_conjunto as nom_usina,
        tipo_usina,
        null as tipo_combustivel -- FatorCapacidade não tem combustível
    from {{ ref('stg_fator_capacidade') }}
)
select
    {{ dbt_utils.generate_surrogate_key(['id_ons', 'ceg', 'nom_usina']) }} as id_usina,
    id_ons,
    ceg,
    nom_usina,
    tipo_usina,
    tipo_combustivel
from all_usinas
