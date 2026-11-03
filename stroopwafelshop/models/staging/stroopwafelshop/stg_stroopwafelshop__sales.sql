with source as (

    select * from {{ source('stroopwafelshop', 'Sales') }}

),

renamed as (

    select
        cast(sales_id as int64)             as sale_id,
        cast(employee_id as int64)          as employee_id,
        cast(date as date)                  as sale_date,
        cast(time as time)                  as sale_time,
        datetime(cast(date as date), cast(time as time)) as sold_at,
        trim(weekday)                       as weekday_name,
        trim(payment_type)                  as payment_type,
        cast(total_price as numeric)        as total_price,
        cast(total_discount as numeric)     as total_discount

    from source

)

select * from renamed
