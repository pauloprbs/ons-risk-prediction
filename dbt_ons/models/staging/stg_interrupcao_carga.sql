-- Limpa e prepara os dados de interrupção de carga
SELECT
    TO_TIMESTAMP(din_interrupcaocarga) AS timestamp_interrupcao,
    id_estado,
    TRY_CAST(REPLACE(val_energianaosuprida_mwh, ',', '.') AS FLOAT) AS energia_nao_suprida_mwh
FROM {{ source('ons_data_raw', 'INTERRUPCAO_CARGA_RAW') }}
WHERE id_estado = 'GO'