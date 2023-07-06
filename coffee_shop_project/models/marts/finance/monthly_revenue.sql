{% set product_categories = [
    'coffee beans',
    'merch',
    'brewing supplies'
] %}

with revenue as (

    select
        date_trunc(order_created_at, month) as date_month,

        {% for product_category in product_categories %}
        sum(case 
                when product_category = '{{ product_category }}' 
                then price end) 
                as {{ product_category | replace(' ', '_') }}_amount
        {% if not loop.last %}
            ,
        {% endif %}
        {% endfor %}

    from {{ ref('int_orders_fanned_out_to_items') }}
    group by 1
)

select * from revenue