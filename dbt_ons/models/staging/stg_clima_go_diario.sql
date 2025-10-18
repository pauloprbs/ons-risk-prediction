-- Limpa e prepara os dados de clima
SELECT
    TO_DATE("data") AS dia, -- "data" precisa de aspas por ser palavra reservada
    TRY_CAST(ghi AS FLOAT) AS ghi_kwh_m2_dia,
    TRY_CAST(temp2m_c AS FLOAT) AS temp_media_c,
    TRY_CAST(precipitacao_mm AS FLOAT) AS precipitacao_mm
FROM {{ source('ons_data_raw', 'CLIMA_GO_DIARIO_RAW') }}