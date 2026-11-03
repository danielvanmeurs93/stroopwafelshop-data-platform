with sales as (

    select * from {{ ref('stg_stroopwafelshop__sales') }}

),

sales_lines as (

    select * from {{ ref('fct_sales_lines') }}

),

lines_per_sale as (

    select
        sale_id,
        count(*)                        as line_count,
        sum(quantity_sold)              as quantity_sold,
        sum(gross_amount)               as gross_amount,
        sum(cost_amount)                as cost_amount,
        sum(margin_amount)              as margin_amount,
        logical_or(promotion_id is not null) as has_promotion

    from sales_lines
    group by sale_id

),

final as (

    -- left join keeps the sales without lines (zero-value transactions)
    select
        sales.sale_id,
        sales.employee_id,
        sales.sale_date,
        sales.sale_time,
        sales.sold_at,
        sales.weekday_name,
        sales.payment_type,

        coalesce(lines_per_sale.line_count, 0)          as line_count,
        coalesce(lines_per_sale.quantity_sold, 0)       as quantity_sold,
        coalesce(lines_per_sale.gross_amount, 0)        as gross_amount,
        sales.total_discount                            as discount_amount,
        sales.total_price                               as net_amount,
        coalesce(lines_per_sale.cost_amount, 0)         as cost_amount,
        coalesce(lines_per_sale.margin_amount, 0)       as margin_amount,
        coalesce(lines_per_sale.has_promotion, false)   as has_promotion,
        lines_per_sale.sale_id is null                  as is_empty_sale

    from sales
    left join lines_per_sale
        on sales.sale_id = lines_per_sale.sale_id

)

select * from final
