-- models/staging/stg_ena_diario.sql
-- Limpa e filtra os dados de Energia Afluente (ENA)

SELECT
    TO_DATE(ena_data) AS dia,
    nom_subsistema AS subsistema,
    TRY_CAST(REPLACE(ena_bruta_regiao_percentualmlt, ',', '.') AS FLOAT) AS ena_percentual_mlt_seco
FROM {{ source('ons_data_raw', 'ENA_DIARIO_RAW') }}
WHERE nom_subsistema = 'SUDESTE'