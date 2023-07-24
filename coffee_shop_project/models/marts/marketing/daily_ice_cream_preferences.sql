with date_days as (

    -- Get the date range from our data 
    -- Generate a list of dates within the range
    select 
        date_day
    from unnest(generate_date_array(
        (select min(date(created_at)) from {{ ref('ice_cream_flavor_preferences') }}),
        (select max(date(created_at)) from {{ ref('ice_cream_flavor_preferences') }}),
        interval 1 day
        )) as date_day
  ),

daily_preferences as (
    select *  from {{ ref('ice_cream_flavor_preferences') }}
),

daily_counts as (

    select 
        date_days.date_day,
        daily_preferences.favorite_ice_cream_flavor,
        count(distinct daily_preferences.github_username) as flavor_count
    from date_days
    left join daily_preferences 
        on date_day between date(dbt_valid_from) and ifnull(date(dbt_valid_to), date("2099-12-31"))
    group by 1, 2
), 

daily_ranks as (

    -- Sort the flavors by popularity
    select
        *,
        row_number() over (partition by date_day order by flavor_count desc) as flavor_rank
    from daily_counts
)

select 
    *
from daily_ranks 
order by 1, 4