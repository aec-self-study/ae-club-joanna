with orders as (
    select
      *
    from {{ ref('stg_coffee_shop__orders') }}
),

order_items as (
    select
      *
    from {{ ref('stg_coffee_shop__order_items') }}
),

products as (
    select
      *
    from {{ ref('stg_coffee_shop__products') }}
),

product_prices as (
    select
      *
    from {{ ref('stg_coffee_shop__product_prices') }}
),

order_details as (
    select
      order_items.order_item_id,
      orders.order_id,
      orders.order_created_at,
      products.product_name,
      products.product_category,
      product_prices.price
    from orders
    left join order_items
      on orders.order_id = order_items.order_id
    left join products
      on order_items.product_id = products.product_id
    left join product_prices
      on products.product_id = product_prices.product_id
      and product_prices.price_valid_from <= orders.order_created_at
      and product_prices.price_valid_to >= orders.order_created_at
)

select * from order_details