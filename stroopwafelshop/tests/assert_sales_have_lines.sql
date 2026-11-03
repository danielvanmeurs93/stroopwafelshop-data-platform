-- Every sale should have at least one sales line. The source contains zero-value
-- sales without lines; this warns about them instead of failing the build.
{{ config(severity = 'warn') }}

select
    sales.sale_id,
    sales.sale_date,
    sales.total_price

from {{ ref('stg_stroopwafelshop__sales') }} as sales
left join {{ ref('stg_stroopwafelshop__sales_lines') }} as sales_lines
    on sales.sale_id = sales_lines.sale_id
where sales_lines.sale_id is null
