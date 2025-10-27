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