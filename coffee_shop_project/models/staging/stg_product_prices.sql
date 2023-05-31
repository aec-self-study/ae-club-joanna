with source as (
    select * from {{ source('coffee_shop', 'product_prices') }}
),

renamed as (
    select
        id as product_price_id,
        product_id,

        price,

        -- timestamps
        created_at as price_valid_from,
        ended_at as price_valid_to
    from source
)

select * from renamed