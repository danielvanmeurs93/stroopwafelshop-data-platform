with products as (

    select * from {{ ref('stg_stroopwafelshop__products') }}

),

final as (

    select
        product_id,
        product_name,
        unit_price,
        unit_cost,
        unit_price - unit_cost                              as unit_margin,
        safe_divide(unit_price - unit_cost, unit_price)     as unit_margin_pct

    from products

)

select * from final
