with customers as ( 
  select
    id,
    name,
    email
  from `analytics-engineers-club.coffee_shop.customers`
),

orders as (
  select
    customer_id,
    min(created_at) first_order_at,
    count(id) as number_of_orders
  from `analytics-engineers-club.coffee_shop.orders`
  group by customer_id
)

  select
    customer_id,
    name,
    email,
    first_order_at,
    number_of_orders
  from customers
  left join orders 
    on customers.id = orders.customer_id
  order by first_order_at
  limit 5
;