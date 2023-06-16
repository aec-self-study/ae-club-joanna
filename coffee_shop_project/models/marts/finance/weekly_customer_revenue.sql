with orders as (
    select * from {{ ref('stg_coffee_shop__orders')}}
),

all_weeks as (
    select * from {{ ref('all_weeks')}}
),

-- get revenue generated per customer per week
weekly_orders as (
    select
        customer_id,
        date_trunc(order_created_at, week) as order_week,
        sum(order_total) as revenue
    from orders
    group by 1,2
),

-- find the week of customer's first order
first_week as (
    select
        customer_id,
        min(order_week) as first_order_week
    from weekly_orders
    group by 1
),

-- create one record per week since first order for each customer
customer_weeks as (
    select
        first_week.customer_id,
        first_week.first_order_week,
        all_weeks.date_week,
        date_diff(
            -- cast is required by BigQuery
            cast(all_weeks.date_week as datetime),
            cast(first_week.first_order_week as datetime),
            week
        ) as week_number
    from first_week
    inner join all_weeks 
        -- we want to fill in all the missing weeks per customer
        on first_week.first_order_week <= all_weeks.date_week
),

all_weeks_revenue as (
    select
        customer_weeks.customer_id,
        customer_weeks.first_order_week,
        customer_weeks.date_week,
        customer_weeks.week_number,
        coalesce(weekly_orders.revenue, 0) as total_revenue,
        sum(weekly_orders.revenue) over (
            partition by customer_weeks.customer_id
            order by customer_weeks.date_week
            rows between unbounded preceding and current row
        ) as total_cumulative_revenue
    from customer_weeks
    left join weekly_orders 
        on customer_weeks.customer_id = weekly_orders.customer_id
        and customer_weeks.date_week = weekly_orders.order_week
)

select * from all_weeks_revenue