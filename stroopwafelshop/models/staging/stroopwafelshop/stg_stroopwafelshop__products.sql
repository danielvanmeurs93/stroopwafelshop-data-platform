with source as (

    select * from {{ source('stroopwafelshop', 'Products') }}

),

renamed as (

    select
        cast(id as int64)               as product_id,
        trim(product_name)              as product_name,
        cast(unit_cost as numeric)      as unit_cost,
        cast(unit_price as numeric)     as unit_price

    from source

)

select * from renamed
