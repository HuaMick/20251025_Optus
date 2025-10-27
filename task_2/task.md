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