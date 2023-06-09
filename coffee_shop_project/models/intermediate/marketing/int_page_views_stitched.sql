with page_views as (
    select * from {{ ref('stg_web_tracking__page_views') }}
),

visitors as (
    select * from {{ ref('int_visitors') }}
),

joined as (
    select
        page_views.*,
        -- Take customer id if avaliable, else visitor id
        coalesce(
            visitors.first_customer_id, 
            page_views.visitor_id
        ) as stitched_visitor_id
    from page_views
    left join visitors
        on page_views.visitor_id = visitors.visitor_id
)

select * from joined