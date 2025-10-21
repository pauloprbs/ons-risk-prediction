-- Limpa e prepara os dados de geração de usina
SELECT
    TO_TIMESTAMP(din_instante) AS timestamp_geracao,
    id_estado,
    nom_tipousina AS tipo_usina,
    TRY_CAST(REPLACE(val_geracao, ',', '.') AS FLOAT) AS geracao_mwh
FROM {{ source('ons_data_raw', 'GERACAO_USINA_RAW') }}
WHERE id_estado = 'GO' -- Filtro importante