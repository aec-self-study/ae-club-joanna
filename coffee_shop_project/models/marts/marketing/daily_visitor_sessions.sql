{{ config(
    materialized='table'
) }}

select
    session_date,
    count(session_number) as num_sessions,
    count(distinct stitched_visitor_id) as num_visitors,
    round(avg(session_duration_minutes), 2) as avg_session_duration,
    round(avg(pages_viewed), 2) as avg_pages_viewed,
    sum(case when ended_in_purchase = true then 1 else 0 end) as num_purchases

from {{ ref('int_visitor_sessions_metadata') }}

group by session_date
order by session_date