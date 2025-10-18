-- Limpa e filtra os dados de intercâmbio para o subsistema Sudeste

SELECT
    TO_TIMESTAMP(din_instante) AS timestamp_intercambio,
    nom_subsistema_origem AS subsistema_origem,
    nom_subsistema_destino AS subsistema_destino,
    TRY_CAST(REPLACE(val_intercambiomwmed, ',', '.') AS FLOAT) AS intercambio_mwh
FROM {{ source('ons_data_raw', 'INTERCAMBIO_NACIONAL_RAW') }}
-- Pré-filtra para manter apenas registros relevantes para o balanço do Sudeste
WHERE subsistema_origem = 'SUDESTE' OR subsistema_destino = 'SUDESTE'