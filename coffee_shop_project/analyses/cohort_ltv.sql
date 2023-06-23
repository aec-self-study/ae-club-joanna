with weekly_customer_revenue as(
    select  * from {{ ref('weekly_revenue_by_first_order_week') }}
),

cohort_revenue as (
    select
        first_order_week,
        week_number,
        sum(weekly_revenue) as weekly_revenue,
        sum(cumulative_revenue) as cumulative_revenue
    from weekly_customer_revenue
    group by 1, 2
),

cohort_size as (
    select
        first_order_week,
        count(*) as cohort_size
    from weekly_customer_revenue
    where week_number = 0
    group by 1
),

normalized_cohorts as (
    select
        *,
        weekly_revenue/ cohort_size as avg_weekly_revenue,
        cumulative_revenue / cohort_size as avg_cumulative_revenue
    from cohort_revenue
    left join cohort_size 
        using(first_order_week)
    order by 1, 2
)

select * from normalized_cohorts

