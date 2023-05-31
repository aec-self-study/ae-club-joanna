with source as (
    select * from {{ source('coffee_shop', 'products') }}
),

renamed as (
    select
        id as product_id,

        name,
        category,

        -- timestamps
        created_at
    from source
)

select * from renamed