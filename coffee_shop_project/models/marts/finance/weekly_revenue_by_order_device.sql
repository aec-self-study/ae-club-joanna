with orders as (
    select * from {{ ref('stg_coffee_shop__orders') }}
),

all_weeks as (
    select * from {{ ref('all_weeks') }}
),

-- take all orders with the respective device
devices as (
    select
        stitched_visitor_id,
        device_type,
        page_view_created_at
    from {{ ref('int_page_views_stitched') }}
    where page_name = 'order-confirmation'
),

-- get revenue generated per customer per week by device
weekly_orders as (
    select
        orders.customer_id,
        device_type,
        date_trunc(order_created_at, week) as order_week,
        sum(order_total) as revenue
    from orders
    left join devices
        on orders.customer_id = devices.stitched_visitor_id
        and order_created_at = page_view_created_at
    group by 1, 2, 3
),

-- find the week of customer's first order per device
device_first_week as (
    select
        customer_id,
        device_type,
        min(order_week) as first_order_week
    from weekly_orders
    group by 1, 2
),

-- create one record per week since first order for each customer
customer_weeks as (
    select
        device_first_week.customer_id,
        device_first_week.device_type,
        all_weeks.date_week,
        date_diff(
            -- cast is required by BigQuery
            cast(all_weeks.date_week as datetime),
            cast(device_first_week.first_order_week as datetime),
            week
        ) as week_number
    from device_first_week
    inner join all_weeks 
        -- we want to fill in all the missing weeks per customer
        on device_first_week.first_order_week <= all_weeks.date_week
),

all_weeks_revenue as (
    select
        customer_weeks.customer_id,
        customer_weeks.device_type,
        customer_weeks.date_week,
        customer_weeks.week_number,
        coalesce(weekly_orders.revenue, 0) as weekly_revenue,
        sum(weekly_orders.revenue) over (
            partition by customer_weeks.customer_id,
                         customer_weeks.device_type
            order by customer_weeks.date_week
            rows between unbounded preceding and current row
        ) as cumulative_revenue
    from customer_weeks
    left join weekly_orders 
        on customer_weeks.customer_id = weekly_orders.customer_id
        and customer_weeks.date_week = weekly_orders.order_week
        and customer_weeks.device_type = weekly_orders.device_type
)

select * from all_weeks_revenue
