with promotions as (

    select * from {{ ref('stg_stroopwafelshop__promotions') }}

),

final as (

    select
        promotion_id,
        promotion_name,
        promotion_description,
        product_id,
        start_date,
        end_date,
        date_diff(end_date, start_date, day) + 1   as duration_days,
        discount_rate,
        is_holiday

    from promotions

)

select * from final
