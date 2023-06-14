with page_views as (
    select * from {{ ref('stg_web_tracking__page_views') }}
),

visitors as (
    select * from {{ ref('int_visitors') }}
),

joined as (
    select
        page_views.page_view_id,
        -- Replace all following visitor ids with the first one
        visitors.first_visitor_id as visitor_id,
        page_views.customer_id,
        page_views.page_name,
        page_views.device_type,
        -- Take customer id if avaliable, else first visitor id
        coalesce(
            visitors.first_customer_id, 
            visitors.first_visitor_id
        ) as stitched_visitor_id,
        page_views.page_view_created_at
    from page_views
    left join visitors
        on page_views.visitor_id = visitors.visitor_id
)

select * from joined