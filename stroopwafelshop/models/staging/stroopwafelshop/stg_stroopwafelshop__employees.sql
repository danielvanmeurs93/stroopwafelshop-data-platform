with source as (

    select * from {{ source('stroopwafelshop', 'Employees') }}

),

renamed as (

    select
        cast(id as int64)                  as employee_id,
        trim(name)                         as first_name,
        trim(last_name)                    as last_name,
        cast(hire_date as date)            as hire_date,
        cast(hourly_rate as numeric)       as hourly_rate,
        cast(date_of_birth as date)        as date_of_birth,
        nullif(trim(contact_number), '')   as contact_number

    from source

)

select * from renamed
