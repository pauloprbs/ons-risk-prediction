-- Limpa e renomeia dados da API de carga programada

SELECT
    din_referenciautc AS timestamp_referencia,
    val_cargaglobalprogramada AS carga_programada_mwh
FROM {{ source('ons_data_raw', 'CARGA_PROGRAMADA_RAW') }}