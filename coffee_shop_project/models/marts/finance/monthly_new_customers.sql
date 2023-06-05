{{ config(
    materialized='table'
) }}

select
    date_trunc(first_order_at, month) as order_month,
    count(*) as new_customers
 
from {{ ref('int_customer_order_count') }}

group by 1