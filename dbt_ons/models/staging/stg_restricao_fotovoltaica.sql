-- Limpa e filtra dados de restrição de geração fotovoltaica

SELECT
    TO_TIMESTAMP(din_instante) AS timestamp_restricao,
    id_estado,
    -- Converte texto para número, tratando vírgulas
    TRY_CAST(REPLACE(val_geracao, ',', '.') AS FLOAT) AS geracao_mwh,
    TRY_CAST(REPLACE(val_geracaoreferencia, ',', '.') AS FLOAT) AS geracao_referencia_mwh,
    cod_razaorestricao AS razao_restricao,
    cod_origemrestricao AS origem_restricao
FROM {{ source('ons_data_raw', 'RESTRICAO_FOTOVOLTAICA_RAW') }}
WHERE id_estado = 'GO'