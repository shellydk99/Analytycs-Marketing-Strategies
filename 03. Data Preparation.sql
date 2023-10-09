------ DATA PREPARATION ------

--Backup data and choose the needed coloumn
USE db_cyclistic
CREATE TABLE db_cyclistic..datatrip_2022 (
	trip_id varchar(100) primary key,
	user_type varchar(50),
	bike_type varchar(50),
	start_station varchar(100),
	end_station varchar(100),
	)

--Insert data into table
INSERT INTO db_cyclistic..datatrip_2022 (trip_id, user_type, bike_type, start_station, end_station)
SELECT ride_id, member_casual, rideable_type, start_station_name, end_station_name
FROM db_cyclistic..tripdata_2022;

--Make sure the count of data is same as tripdata_2022
SELECT TOP 5 * FROM db_cyclistic..datatrip_2022;

-- Create date_start_time
ALTER TABLE db_cyclistic..datatrip_2022
ADD [date_start_time] DATE;

UPDATE d1
SET d1.[date_start_time] = CAST(d2.started_at AS DATE)
FROM db_cyclistic..datatrip_2022 AS d1
INNER JOIN db_cyclistic..tripdata_2022 AS d2 ON d1.trip_id = d2.ride_id;

-- Create day_of_week
ALTER TABLE db_cyclistic..datatrip_2022
ADD [day_of_week] VARCHAR(20);

UPDATE db_cyclistic..datatrip_2022
SET day_of_week = DATENAME(WEEKDAY, date_start_time);

-- Create new column start_time
ALTER TABLE db_cyclistic..datatrip_2022
ADD [start_time] TIME;

--Update start_time into column
UPDATE d1
SET d1.[start_time] = CAST(d2.started_at AS TIME)
FROM db_cyclistic..datatrip_2022 AS d1
INNER JOIN db_cyclistic..tripdata_2022 AS d2 ON d1.trip_id = d2.ride_id;

--Create new column end_time
ALTER TABLE db_cyclistic..datatrip_2022
ADD [end_time] TIME;

--Update end_time into column
UPDATE d1
SET d1.[end_time] = CAST(d2.ended_at AS TIME)
FROM db_cyclistic..datatrip_2022 AS d1
INNER JOIN db_cyclistic..tripdata_2022 AS d2 ON d1.trip_id = d2.ride_id;

--Create new column duration
ALTER TABLE db_cyclistic..datatrip_2022
ADD ride_length TIME;

UPDATE db_cyclistic..datatrip_2022
SET ride_length = CONVERT(TIME, 
    DATEADD(SECOND, DATEDIFF(SECOND, start_time, end_time), 0));

-- Find duration less than 1 second, and more tha 24 hours
SELECT DurationCategory, COUNT(*) AS Count
	FROM (
		SELECT *,
			   CASE
				   WHEN DATEDIFF(SECOND, '00:00:00', ride_length) >= 86400 THEN 'More than 24 hours'
				   WHEN DATEDIFF(SECOND, '00:00:00', ride_length) < 1 THEN 'Less than 1 second'
				   ELSE 'Between 1 second and 24 hours'
			   END AS DurationCategory
		FROM db_cyclistic..datatrip_2022
	) AS Categories
	GROUP BY DurationCategory;

-- Drop rows less than 1 second
DELETE FROM db_cyclistic..datatrip_2022					-- 239 rows affected
WHERE DATEDIFF(SECOND, '00:00:00', ride_length) < 1;
