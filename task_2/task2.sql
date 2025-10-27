-- Greenfield Deployment Procedure
-- For greenfield deployment no need for snapshots

-- Version update deployment
-- Requires backups/snapshot and rollback logic
-- Ideally have a staging environment to test deployment before production

CREATE OR REPLACE PROCEDURE `bigquery-362207.production_data_migration.deploy_dataset`(
  IN source_project STRING,
  IN source_dataset STRING,
  IN target_project STRING,
  IN target_dataset STRING
)
BEGIN
  -- All variable declarations must be at the start of the block.
  DECLARE tables_to_migrate ARRAY<STRUCT<name STRING, type STRING>>;
  DECLARE i INT64 DEFAULT 0;
  DECLARE current_item STRUCT<name STRING, type STRING>;
  DECLARE view_definition STRING;
  DECLARE external_table_options STRING;


  -- 1. Fetch all relevant table and view names from the source, excluding SNAPSHOTS.
  EXECUTE IMMEDIATE FORMAT("""
    SELECT ARRAY_AGG(STRUCT(table_name AS name, table_type AS type))
    FROM `%s.%s.INFORMATION_SCHEMA.TABLES`
    WHERE table_type IN (
      "BASE TABLE",
      "CLONE",          -- Treat clones as base tables for deployment
      "VIEW",
      "MATERIALIZED VIEW",
      "EXTERNAL"
      )
  """, source_project, source_dataset)
  INTO tables_to_migrate;


  -- 2. Loop through the array of objects to migrate.
  WHILE i < ARRAY_LENGTH(tables_to_migrate) DO
    SET current_item = tables_to_migrate[OFFSET(i)];


    -- 3. Handle different object types with specific logic.
    IF current_item.type IN ('BASE TABLE', 'CLONE') THEN
      -- For tables and clones, use CLONE for a fast, low-cost copy.
      EXECUTE IMMEDIATE FORMAT("""
        CREATE OR REPLACE TABLE `%s.%s.%s`
        CLONE `%s.%s.%s`
      """, target_project, target_dataset, current_item.name,
           source_project, source_dataset, current_item.name);


    ELSEIF current_item.type IN ('VIEW', 'MATERIALIZED VIEW') THEN
      -- For views, get the original definition and re-create it.
      EXECUTE IMMEDIATE FORMAT("""
        SELECT view_definition
        FROM `%s.%s.INFORMATION_SCHEMA.VIEWS`
        WHERE table_name = '%s'
      """, source_project, source_dataset, current_item.name)
      INTO view_definition;


      -- Re-create the view or materialized view in the target dataset.
      EXECUTE IMMEDIATE FORMAT("""
        CREATE OR REPLACE %s `%s.%s.%s` AS
        %s
      """, current_item.type, target_project, target_dataset, current_item.name, view_definition);

    ELSEIF current_item.type = 'EXTERNAL' THEN
        -- For external tables, get their options and recreate them.
        EXECUTE IMMEDIATE FORMAT(r"""
            SELECT STRING_AGG(
                FORMAT('%%s = %%s', option_name, option_value), ', '
            )
            FROM `%s.%s.INFORMATION_SCHEMA.TABLE_OPTIONS`
            WHERE table_name = '%s'
        """, source_project, source_dataset, current_item.name)
        INTO external_table_options;

        -- Re-create the external table in the target dataset with its options.
        IF external_table_options IS NOT NULL THEN
            EXECUTE IMMEDIATE FORMAT("""
                CREATE OR REPLACE EXTERNAL TABLE `%s.%s.%s`
                OPTIONS (%s)
            """, target_project, target_dataset, current_item.name, external_table_options);
        END IF;

    END IF;


    SET i = i + 1;
  END WHILE;
END;
