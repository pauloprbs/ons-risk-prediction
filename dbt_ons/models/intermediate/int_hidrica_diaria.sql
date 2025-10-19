-- models/intermediate/int_hidrica_diaria.sql
-- Alinha os dados diários de EAR e ENA com a espinha dorsal de datas

select
    d.date_day as timestamp,
    e.ear_percentual_seco,
    n.ena_percentual_mlt_seco
from {{ ref('int_all_days') }} d
left join {{ ref('stg_ear_diario') }} e 
    on d.date_day = to_date(e.dia)
left join {{ ref('stg_ena_diario') }} n 
    on d.date_day = to_date(n.dia)