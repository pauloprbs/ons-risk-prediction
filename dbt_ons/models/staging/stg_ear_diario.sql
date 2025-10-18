-- Limpa e filtra os dados de Energia Armazenada (EAR)

SELECT
    TO_DATE(ear_data) AS dia,
    nom_subsistema AS subsistema,
    TRY_CAST(REPLACE(ear_verif_subsistema_percentual, ',', '.') AS FLOAT) AS ear_percentual_seco
FROM {{ source('ons_data_raw', 'EAR_DIARIO_RAW') }}
WHERE subsistema = 'SUDESTE' -- Conforme lógica do notebook 05