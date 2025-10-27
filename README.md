# 20251025_Optus

/*

Task 1

A telecom company collects real-time network event logs from thousands of cell towers across the country. Each event includes:

	- tower_id,
	- timestamp,
	- event_type (e.g., dropped_call, handover, congestion),
	- device_id,
	- signal_strength,
	- latitude,
	- longitude 

You are tasked with designing a data pipeline that:

	- Ingests this data in near real-time
	- Cleans and validates the data (e.g., removes duplicates, filters out invalid signal strengths)
	- Stores it in a format optimised for querying network performance by region and time

Deliverables:

	- Provide documentation explaining:
		- Your architecture and tool choices (e.g., Kafka, Spark, Flink, Airflow)
		
	- Provide a architectural diagram that shows the different components of the pipeline:
		- How the pipeline handles scalability and fault tolerance
		- How you would monitor and test this pipeline in production

*/

/*

Task 2

A team is looking to deploy scripts from various development environments into into their production environment, how might you efficiently migrate the scripts across cloud billing projects and data sets?

Deliverables:

	- Design a script using procedural SQL and dynamic SQL to perform this task
	- Explain what considerations you would make if this is a greenfield deployment
	- Explain what considerations you would make if this is a version update deployment

Note: 

	- BQ file structures follow a billing-project.data-set.data-object format
	- BQ meta-data is stored in billing-project.data-set.INFORMATION_SCHEMA.TABLES (includes views):
	
      FIELD         TYPE      DESCRIPTION
      table_catalog	STRING	  The project ID of the project that contains the dataset.
      table_schema	STRING	  The name of the dataset that contains the table or view. Also referred to as the datasetId.
      table_name	STRING	  The name of the table or view. Also referred to as the tableId.
      table_type	STRING	  The table type; one of the following:
                              BASE TABLE: A standard table
                              CLONE: A table clone
                              SNAPSHOT: A table snapshot
                              VIEW: A view
                              MATERIALIZED VIEW: A materialized view or materialized view replica
                              EXTERNAL: A table that references an external data source
      ddl           STRING    The DDL statement that can be used to recreate the table, such as CREATE TABLE or CREATE VIEW

Example locations:

	- dev.reference_data.state_gegraphic_data
	- dev.reference_data.state_gegraphic_data_transformation_view
	- dev.reference_data.delivery_area_data
	- dev.reference_data.delivery_area_data_transformation_view
	- dev.ecom_data.purchase_data
	- dev.ecom_data.purchase_data_transformation_view
	- production.reference_data
	- production.ecom_data

*/

/*

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

*/