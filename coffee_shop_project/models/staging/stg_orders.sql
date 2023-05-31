with source as (

    select * from {{source('coffee_shop', 'orders') }}

),

renamed as (

    select

        id as order_id,
        customer_id,
        total as total_amount,
        address,
        state,
        zip,

        -- timestamps
        created_at

    from source

)

select * from renamed