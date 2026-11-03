with source as (

    select * from {{ source('stroopwafelshop', 'Sales_lines') }}

),

renamed as (

    select
        cast(id as int64)                   as sales_line_id,
        cast(sales_id as int64)             as sale_id,
        cast(product_id as int64)           as product_id,
        -- Google Sheets exports this as a float string ("1.0"); empty means no promotion
        cast(cast(nullif(trim(promotion_id), '') as float64) as int64) as promotion_id,
        cast(date as date)                  as sale_date,
        cast(quantity_sold as int64)        as quantity_sold,
        cast(unit_price as numeric)         as unit_price,
        cast(discount_rate as numeric)      as discount_rate,
        cast(unit_discount as numeric)      as unit_discount,
        cast(total_discount as numeric)     as total_discount,
        -- net amount: unit_price * quantity_sold - total_discount
        cast(total_price as numeric)        as total_price

    from source

)

select * from renamed
