-- Limpa e filtra os dados de Custo Marginal de Operação (CMO)

SELECT
    TO_TIMESTAMP(din_instante) AS timestamp_semana,
    nom_subsistema AS subsistema,
    TRY_CAST(REPLACE(val_cmomediasemanal, ',', '.') AS FLOAT) AS cmo_medio_semanal
FROM {{ source('ons_data_raw', 'CMO_SEMANAL_RAW') }}
WHERE subsistema = 'SUDESTE' -- Conforme lógica do notebook 07