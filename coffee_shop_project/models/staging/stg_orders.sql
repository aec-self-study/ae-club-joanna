with source as (
    select * from {{source('coffee_shop', 'orders') }}
),

renamed as (
    select
        id as order_id,
        customer_id,

        total as order_total,
        address as order_address,
        state as order_state,
        zip as order_zip,

        -- timestamps
        created_at as order_created_at
    from source
)

select * from renamed