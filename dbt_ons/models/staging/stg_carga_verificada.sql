-- Limpa e renomeia dados da API de carga verificada

SELECT
    din_referenciautc AS timestamp_referencia,
    val_cargaglobal AS carga_verificada_mwh
FROM {{ source('ons_data_raw', 'CARGA_VERIFICADA_RAW') }}