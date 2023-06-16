with weeks as (
    {{ dbt_utils.date_spine(
        datepart="week",
        start_date="'2020-12-27'",
        end_date="'2021-12-26'"
    ) }}
)

select
    cast(date_week as timestamp) as date_week
from weeks