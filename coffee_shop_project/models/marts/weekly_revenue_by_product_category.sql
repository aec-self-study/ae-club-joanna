with order_details as (
    select
      *
    from {{ ref('order_details') }}
),

aggregated as (
    select 
      cast(date_trunc(order_created_at, week) as date) as date_week,
      product_category,
      sum(price) as revenue_usd
    from order_details
    group by date_week, product_category
    order by date_week, product_category
)

select
  *
from aggregated  