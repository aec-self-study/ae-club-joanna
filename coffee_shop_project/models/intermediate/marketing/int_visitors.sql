-- Get the first customer_id per visitor, if available

with visitors as (
    select distinct
        visitor_id,
        first_value(customer_id ignore nulls) over (
            partition by visitor_id 
            order by page_view_created_at
            rows between unbounded preceding and unbounded following
        ) as first_customer_id,

        min(page_view_created_at) over (
            partition by visitor_id
        ) as first_page_view_at

    from {{ ref('stg_web_tracking__page_views') }}
),

final as (
    select
        visitor_id,
        first_value(visitor_id) over (
            partition by coalesce(first_customer_id, visitor_id)
            order by first_page_view_at
        ) as first_visitor_id,
        first_customer_id
    from visitors
)

select * from final