-- Get the first customer_id per visitor, if available

with visitors as (
    select distinct
        visitor_id,
        first_value(customer_id ignore nulls) over (
            partition by visitor_id 
            order by page_view_created_at
            rows between unbounded preceding and unbounded following
        ) as first_customer_id

    from {{ ref('stg_web_tracking__page_views') }}
)

select * from visitors