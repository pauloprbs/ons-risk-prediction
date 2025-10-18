-- models/intermediate/int_all_days.sql
-- Não precisamos de um "select ... from" ao redor dela.

{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('" ~ var('start_year') ~ "-01-01' as date)",
    end_date="cast('" ~ var('end_year') ~ "-12-31' as date)"
   )
}}