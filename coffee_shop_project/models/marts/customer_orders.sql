{{ config(
    materialized='table'
) }}

with customer_orders as (
    select
        customer_id,
        count(*) as number_of_orders,
        min(order_created_at) as first_order_at
    from {{ ref('stg_orders') }} as orders
    group by 1
)

select
    customer_orders.customer_id,
    customers.customer_name,
    customers.customer_email,
    customer_orders.first_order_at,
    customer_orders.number_of_orders

from {{ ref('stg_customers') }} as customers
left join customer_orders
    on customers.customer_id = customer_orders.customer_id