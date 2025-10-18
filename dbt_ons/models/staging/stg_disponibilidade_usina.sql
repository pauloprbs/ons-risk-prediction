-- Limpa e filtra os dados de disponibilidade de usinas

SELECT
    TO_TIMESTAMP(din_instante) AS timestamp_ocorrencia,
    id_estado,
    TRY_CAST(REPLACE(val_dispoperacional, ',', '.') AS FLOAT) AS disponibilidade_operacional_mwh
FROM {{ source('ons_data_raw', 'DISPONIBILIDADE_USINA_RAW') }}
WHERE id_estado = 'GO' -- Conforme lógica do notebook 07