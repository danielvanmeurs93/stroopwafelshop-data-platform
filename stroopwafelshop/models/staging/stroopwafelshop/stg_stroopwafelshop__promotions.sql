with source as (

    select * from {{ source('stroopwafelshop', 'Promotions') }}

),

renamed as (

    select
        cast(id as int64)                   as promotion_id,
        cast(product_id as int64)           as product_id,
        trim(name)                          as promotion_name,
        trim(description)                   as promotion_description,
        cast(start_date as date)            as start_date,
        cast(end_date as date)              as end_date,
        cast(discount_rate as numeric)      as discount_rate,
        -- BigQuery casts 'True'/'False' to BOOL case-insensitively
        cast(is_holiday as bool)            as is_holiday

    from source

)

select * from renamed
