
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with source_data as (

    select
        customer_id.value as customer_id,
        customer_address.value as customer_address,
        customer_name.value as customer_name,
        __op as source_operation,
        __table as source_table,
        from_unixtime(
            __source_ts_ms/1000,
            'yyyy-MM-dd HH:mm:ss'
        ) as source_timestamp
    from {{ source('the_shop', 'customers') }}

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
