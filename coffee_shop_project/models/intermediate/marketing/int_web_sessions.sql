with page_views as (
    select * from {{ ref('int_page_views_stitched') }}
),

with_previous_next_page_view as (
    select
        *,
        lag(page_view_created_at) over (
            partition by stitched_visitor_id
            order by page_view_created_at
        ) as previous_page_view_at,

        lead(page_view_created_at) over (
            partition by stitched_visitor_id
            order by page_view_created_at
        ) as next_page_view_at
    from page_views
),

with_session_start as (
    select
        *,
        case 
          when timestamp_diff(page_view_created_at, previous_page_view_at, minute) > 30
          or previous_page_view_at is null then 1 else 0
        end as is_session_start
    from with_previous_next_page_view
),

with_session_number as (
    select
        *,
        sum(is_session_start) over (
            partition by stitched_visitor_id
            order by page_view_created_at
            rows between unbounded preceding and current row
        ) as session_number
    from with_session_start
),

with_session_end as (
    select
        *,
        min(page_view_created_at) over (
            partition by stitched_visitor_id
            order by session_number
        ) as session_start_at,
        max(page_view_created_at) over (
            partition by stitched_visitor_id
            order by session_number
        ) as session_end_at

    from with_session_number
),

final as (
    select
        page_view_id,
        visitor_id,
        customer_id,
        stitched_visitor_id,
        session_number,
        page_name,
        device_type,
        page_view_created_at,
        session_start_at,
        session_end_at
    from with_session_end
)

select * from final