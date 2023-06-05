with order_details as (
    select
      *
    from {{ ref('int_orders_fanned_out_to_items') }}
),

orders as (
    select
      order_id,
      customer_id
    from {{ ref('stg_coffee_shop__orders') }}
),

customers as (
    select
      cutomer_id,
      first_order_at
    from from {{ ref('int_customer_order_count') }}
),

combined as (
    select
      order_details.order_id,
      orders.customer_id,
      order_details.product_category,
      case when order_details.order_created_at = customers.first_order_at then 'new' else 'recurring' end as customer_type,
      orders.order_created_at,
      sum(price) as revenue
    from order_details
    left join orders
      on order_details.order_id = order.order_id
    left join customers
      on orders.customer_id = customers.customer_id
    group by 1, 2, 3, 4, 5
),

final as (
    select 
      cast(date_trunc(order_created_at, week) as date) as date_week,
      product_category,
      customer_type,
      sum(price) as revenue_usd
    from order_details
    group by date_week, product_category, customer_type
)

select
  *
from final