with source as (

    select * from {{ source('stroopwafelshop', 'Shifts') }}

),

renamed as (

    select
        cast(employee_id as int64)          as employee_id,
        cast(date as date)                  as shift_date,
        trim(role)                          as role,
        -- hours is a text range like "10:00-14:00"
        parse_time('%H:%M', split(trim(hours), '-')[offset(0)]) as shift_start_time,
        parse_time('%H:%M', split(trim(hours), '-')[offset(1)]) as shift_end_time

    from source

),

final as (

    select
        -- no id in the source; employee + date + start time is unique
        {{ dbt_utils.generate_surrogate_key(['employee_id', 'shift_date', 'shift_start_time']) }} as shift_id,
        employee_id,
        shift_date,
        role,
        shift_start_time,
        shift_end_time,
        time_diff(shift_end_time, shift_start_time, minute) / 60 as shift_duration_hours

    from renamed

)

select * from final
