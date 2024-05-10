
select *
from {{ source('testdb', 'customers') }}