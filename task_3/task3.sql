-- The script is trying to return the latest record 
-- for medium, large and small purchase sizes.
-- It does this by running 3 window function cte's, 
-- one for each purchase size, and using the Qualify key word
-- to return the top record after ordering by purchase date

with purchase_history as(
select
  customer_id, ##PK for output table
  purchase_date,
  purchase_time,
  purchase_price,

-- Invalid CASE statement syntax  
  case purchase_price
	when > 20.0 then 'Medium'
	when > 30.0 then 'Large'
	when < 20.0 then 'Small'
  end purchase_size,

-- Corrected CASE statement syntax
    -- case 
    --     when purchase_price > 30.0 then 'Large'
    --     when purchase_price > 20.0 then 'Medium'
    --     when purchase_price <= 20.0 then 'Small'
    -- end purchase_size,
  item_array
from eccommerce.purchase_logs.online_store
)

-- These cte's perform a full table scan multiple times which is inefficient.
,most_recent_purchase_is_large as(
select
  *
from purchase_history
where purchase_size = 'Large'
qualify rank()over(partition by customer_id order by purchase_date desc) = 1
)

,most_recent_purchase_is_medium as(
select
  *
from purchase_history
where purchase_size = 'Medium'
qualify rank()over(partition by customer_id order by purchase_date desc) = 1
)

,most_recent_purchase_is_small as(
select
  *
from purchase_history
where purchase_size = 'Small'
qualify rank()over(partition by customer_id order by purchase_date desc) = 1
)

select * from most_recent_purchase_is_large
union all
select * from most_recent_purchase_is_medium
union all
select * from most_recent_purchase_is_small

-- Optimized version using a single CTE
--  By partitioning by purchase size as well as customer_id, 
--  we can group the purchases by size and get the most recent 
--  purchase in each size category per customer in a single scan
-- using row_number() = 1.

-- WITH purchase_history AS (
--   SELECT
--     customer_id,
--     purchase_date,
--     purchase_time,
--     purchase_price,
--     case 
--     when purchase_price > 30.0 then 'Large'
--     when purchase_price > 20.0 then 'Medium'
--     when purchase_price <= 20.0 then 'Small'
--     end purchase_size,
--     item_array
--   FROM
--     `eccommerce.purchaselogs.onlinestore`
-- )
-- SELECT
--   *
-- FROM
--   purchase_history
-- QUALIFY
--   ROW_NUMBER() OVER (PARTITION BY customer_id, purchase_size ORDER BY purchase_date DESC, purchase_time DESC) = 1
