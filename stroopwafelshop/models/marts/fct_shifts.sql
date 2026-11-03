with shifts as (

    select * from {{ ref('stg_stroopwafelshop__shifts') }}

),

employees as (

    select * from {{ ref('stg_stroopwafelshop__employees') }}

),

final as (

    select
        shifts.shift_id,
        shifts.employee_id,
        shifts.shift_date,
        shifts.role,
        shifts.shift_start_time,
        shifts.shift_end_time,
        shifts.shift_duration_hours,
        -- current hourly rate, not the rate at time of the shift
        employees.hourly_rate,
        shifts.shift_duration_hours * employees.hourly_rate   as labor_cost

    from shifts
    left join employees
        on shifts.employee_id = employees.employee_id

)

select * from final
