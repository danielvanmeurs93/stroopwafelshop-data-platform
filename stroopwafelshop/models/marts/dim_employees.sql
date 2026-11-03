with employees as (

    select * from {{ ref('stg_stroopwafelshop__employees') }}

),

final as (

    -- date_of_birth and contact_number are deliberately left out: personal
    -- data that no analysis here needs
    select
        employee_id,
        first_name,
        last_name,
        concat(first_name, ' ', last_name)  as full_name,
        hire_date,
        hourly_rate

    from employees

)

select * from final
