with sales_lines as (

    select * from {{ ref('stg_stroopwafelshop__sales_lines') }}

),

sales as (

    select * from {{ ref('stg_stroopwafelshop__sales') }}

),

products as (

    select * from {{ ref('stg_stroopwafelshop__products') }}

),

final as (

    select
        sales_lines.sales_line_id,
        sales_lines.sale_id,
        sales_lines.product_id,
        sales_lines.promotion_id,
        -- sale-level attributes, so analysts do not need to join fct_sales
        sales.employee_id,
        sales.sale_date,
        sales.sold_at,
        sales.payment_type,

        sales_lines.quantity_sold,
        sales_lines.unit_price,
        sales_lines.discount_rate,
        sales_lines.unit_discount,
        sales_lines.unit_price * sales_lines.quantity_sold     as gross_amount,
        sales_lines.total_discount                             as discount_amount,
        sales_lines.total_price                                as net_amount,
        -- current product cost, not the cost at time of sale
        products.unit_cost * sales_lines.quantity_sold         as cost_amount,
        sales_lines.total_price
            - products.unit_cost * sales_lines.quantity_sold   as margin_amount

    from sales_lines
    inner join sales
        on sales_lines.sale_id = sales.sale_id
    left join products
        on sales_lines.product_id = products.product_id

)

select * from final
