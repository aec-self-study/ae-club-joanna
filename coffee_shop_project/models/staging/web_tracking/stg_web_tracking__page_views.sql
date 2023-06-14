with source as (
    select * from {{ source('web_tracking', 'pageviews') }}
),

renamed as (
    select
        id as page_view_id,
        visitor_id,
        customer_id,

        page as page_name,
        device_type,

        -- timestamps
        timestamp as page_view_created_at
    from source
)

select * from renamed