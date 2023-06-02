with orders as (
    select
      *
    from {{ ref('stg_orders') }}
),

order_items as (
    select
      *
    from {{ ref('stg_order_items') }}
),

products as (
    select
      *
    from {{ ref('stg_products') }}
),

product_prices as (
    select
      *
    from {{ ref('stg_product_prices') }}
),

combined as (
    select
      orders.order_id,
      orders.customer_id,
      orders.order_address,
      orders.order_state,
      orders.order_zip,
      orders.order_created_at,
      order_items.order_item_id,
      products.product_name,
      products.product_category,
      product_prices.price,
      min(orders.order_created_at) over (partition by orders.customer_id) as first_order_at,
      count(distinct orders.order_id) over (partition by orders.customer_id) as total_orders,
      count(distinct order_items.order_item_id) over (partition by orders.customer_id, orders.order_id) as items_per_order
    from orders
    left join order_items
      on orders.order_id = order_items.order_id
    left join products
      on order_items.product_id = products.product_id
    left join product_prices
      on products.product_id = product_prices.product_id
      and product_prices.price_valid_from <= orders.order_created_at
      and product_prices.price_valid_to >= orders.order_created_at
),

order_details as (
    select
      order_item_id,
      product_name,
      product_category,
      price,
      order_created_at,
      order_id,
      customer_id,
      case when order_created_at = first_order_at then 'new' else 'returning' end as customer_type,
      order_address,
      order_state,
      order_zip,
      first_order_at,
      total_orders,
      items_per_order
    from combined
)

select * from order_details