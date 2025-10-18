-- Propósito: Agrega a geração diária por tipo de usina (pivot).

select
    date_trunc('DAY', timestamp_geracao) as dia,
    
    -- Usa IFF (IF do Snowflake) para pivotar as linhas em colunas
    sum(iff(tipo_usina = 'EOLIELÉTRICA', geracao_mwh, 0)) as geracao_eolieletrica_diaria,
    sum(iff(tipo_usina = 'FOTOVOLTAICA', geracao_mwh, 0)) as geracao_fotovoltaica_diaria,
    sum(iff(tipo_usina = 'HIDROELÉTRICA', geracao_mwh, 0)) as geracao_hidroeletrica_diaria,
    sum(iff(tipo_usina = 'NUCLEAR', geracao_mwh, 0)) as geracao_nuclear_diaria,
    sum(iff(tipo_usina = 'TÉRMICA', geracao_mwh, 0)) as geracao_termica_diaria,
    sum(geracao_mwh) as geracao_total_diaria_go

from {{ ref('stg_geracao_usina') }}
group by 1