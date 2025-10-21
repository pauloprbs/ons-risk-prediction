-- models/intermediate/int_clima_diario.sql
-- Alinha os dados diários de Clima com a espinha dorsal de datas

select
    d.date_day as timestamp,
    c.ghi_kwh_m2_dia,
    c.temp_media_c,
    c.precipitacao_mm
from {{ ref('int_all_days') }} d
left join {{ ref('stg_clima_go_diario') }} c on d.date_day = c.dia