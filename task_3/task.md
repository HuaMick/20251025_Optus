
Task 3

The following script has been given to you for peer review.

Deliverables:

	- Determine what the script is trying to achieve
	- Give feedback as to any mistakes you note

Script:

with purchase_history as(
select
  customer_id, ##PK for output table
  purchase_date,
  purchase_time,
  purchase_price,
  case purchase_price
	when > 20.0 then 'Medium'
	when > 30.0 then 'Large'
	when < 20.0 then 'Small'
  end purchase_size,
  item_array
from eccommerce.purchase_logs.online_store
)

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