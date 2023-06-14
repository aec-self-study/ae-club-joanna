with all_sessions as (
    select * from {{ ref('int_web_sessions') }}
),

sessions_with_details as (
    select
        stitched_visitor_id,
        session_number,
        date(session_start_at) as session_date,
        round(session_duration_minutes, 2) as session_duration_minutes,
        count(page_view_id) as pages_viewed,
        count(distinct page_name) as unique_pages_viewed,
        count(distinct device_type) as number_of_devices,
        max(case
              when page_name = "order-confirmation" then true else false 
            end) as ended_in_purchase

    from all_sessions
    group by         
        stitched_visitor_id,
        session_number,
        session_date,
        session_duration_minutes
    order by 
        stitched_visitor_id,
        session_number
)

select * from sessions_with_details