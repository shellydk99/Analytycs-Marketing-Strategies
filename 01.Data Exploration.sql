------ Data Exploration -----

--Count total rows
SELECT COUNT(*) FROM db_cyclistic..tripdata_2022;

--Take a look data
SELECT TOP 5 * FROM db_cyclistic..tripdata_2022;

--Check data type
SELECT COLUMN_NAME, DATA_TYPE FROM db_cyclistic.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tripdata_2022';
