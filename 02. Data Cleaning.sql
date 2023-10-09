------ DATA CLEANING ------

--Checking null or missing value
SELECT COUNT(*) - COUNT(ride_id) as missing_ride_id_count,
 COUNT(*) - COUNT(rideable_type) as missing_rideable_type_count,
 COUNT(*) - COUNT(started_at) as missing_started_at_count,
 COUNT(*) - COUNT(ended_at) as missing_ended_at_count,
 COUNT(*) - COUNT(start_station_name) as missing_start_station_name_count,
 COUNT(*) - COUNT(start_station_id) as missing_start_station_count,
 COUNT(*) - COUNT(end_station_name) as missing_end_station_name_count,
 COUNT(*) - COUNT(end_station_id) as missing_end_station_id_count,
 COUNT(*) - COUNT(start_lat) as missing_start_lat_count,
 COUNT(*) - COUNT(start_lng) as missing_start_lng_count,
 COUNT(*) - COUNT(end_lat) as missing_end_lat_count,
 COUNT(*) - COUNT(end_lng) as missing_end_lng_count,
 COUNT(*) - COUNT(member_casual) as missing_member_casual_count
FROM db_cyclistic..tripdata_2022;

--Checking empty value
SELECT
  COUNT(CASE WHEN ride_id = '' THEN 1 ELSE NULL END) AS EmptyCount_ride_id,
  COUNT(CASE WHEN rideable_type = '' THEN 1 ELSE NULL END) AS EmptyCount_rideable_type,
  COUNT(CASE WHEN started_at = '' THEN 1 ELSE NULL END) AS EmptyCount_started_at,
	COUNT(CASE WHEN ended_at = '' THEN 1 ELSE NULL END) AS EmptyCount_ended_at,
	COUNT(CASE WHEN start_station_name = '' THEN 1 ELSE NULL END) AS EmptyCount_start_station_name,
	COUNT(CASE WHEN start_station_id = '' THEN 1 ELSE NULL END) AS EmptyCount_start_station_id,
	COUNT(CASE WHEN end_station_name = '' THEN 1 ELSE NULL END) AS EmptyCount_end_station_name,
	COUNT(CASE WHEN end_station_id = '' THEN 1 ELSE NULL END) AS EmptyCount_end_station_id,
	COUNT(CASE WHEN start_lat = '' THEN 1 ELSE NULL END) AS EmptyCount_start_lat,
	COUNT(CASE WHEN start_lng = '' THEN 1 ELSE NULL END) AS EmptyCount_start_lng,
	COUNT(CASE WHEN end_lat = '' THEN 1 ELSE NULL END) AS EmptyCount_end_lat,
	COUNT(CASE WHEN end_lng = '' THEN 1 ELSE NULL END) AS EmptyCount_end_lng,
	COUNT(CASE WHEN member_casual = '' THEN 1 ELSE NULL END) AS EmptyCount_member_casual
FROM db_cyclistic..tripdata_2022;

--Drop empty value
DELETE FROM db_cyclistic..tripdata_2022			-- 1.298.358 rows affected
WHERE ride_id = ''
   OR rideable_type = ''
   OR started_at = ''
   OR ended_at = ''
   OR start_station_name = ''
   OR start_station_id = ''
   OR end_station_name = ''
   OR end_station_id = ''
   OR start_lat = ''
   OR start_lng = ''
   OR end_lat = ''
   OR end_lng = ''
   OR member_casual = '';

--Checking for duplicate
SELECT COUNT(ride_id) - COUNT(DISTINCT ride_id)		
AS duplicate_rows FROM db_cyclistic..tripdata_2022;

--Drop duplicate rows									-- 11 rows affected
DELETE FROM db_cyclistic..tripdata_2022
WHERE (ride_id) IN (
    SELECT ride_id
    FROM db_cyclistic..tripdata_2022
    GROUP BY ride_id
    HAVING COUNT(*) > 1
);

--Check ride_id length (ride_id should have length of 16) 
SELECT LEN(ride_id) AS length_ride_id, COUNT(ride_id) AS no_of_rows
FROM db_cyclistic..tripdata_2022
GROUP BY len(ride_id)

--Check ride_id which have more than 16
SELECT top 5 *
FROM db_cyclistic..tripdata_2022
WHERE LEN(ride_id) <> 16;

--Update row which have ("")
UPDATE db_cyclistic..tripdata_2022				-- 1.340.704 rows affected
SET 
	ride_id = CASE 
        WHEN LEFT(ride_id, 1) = '"' AND RIGHT(ride_id, 1) = '"'
        THEN SUBSTRING(ride_id, 2, LEN(ride_id) - 2)
        ELSE ride_id END,
	rideable_type = CASE 
        WHEN LEFT(rideable_type, 1) = '"' AND RIGHT(rideable_type, 1) = '"'
        THEN SUBSTRING(rideable_type, 2, LEN(rideable_type) - 2)
        ELSE rideable_type END,
	started_at = CASE 
        WHEN LEFT(started_at, 1) = '"' AND RIGHT(started_at, 1) = '"'
        THEN SUBSTRING(started_at, 2, LEN(started_at) - 2)
        ELSE started_at END,
	ended_at = CASE 
        WHEN LEFT(ended_at, 1) = '"' AND RIGHT(ended_at, 1) = '"'
        THEN SUBSTRING(ended_at, 2, LEN(ended_at) - 2)
        ELSE ended_at END,
	start_station_name = CASE 
        WHEN LEFT(start_station_name, 1) = '"' AND RIGHT(start_station_name, 1) = '"'
        THEN SUBSTRING(start_station_name, 2, LEN(start_station_name) - 2)
        ELSE start_station_name END,
	start_station_id = CASE 
        WHEN LEFT(start_station_id, 1) = '"' AND RIGHT(start_station_id, 1) = '"'
        THEN SUBSTRING(start_station_id, 2, LEN(start_station_id) - 2)
        ELSE start_station_id END,
	end_station_name = CASE 
        WHEN LEFT(end_station_name, 1) = '"' AND RIGHT(end_station_name, 1) = '"'
        THEN SUBSTRING(end_station_name, 2, LEN(end_station_name) - 2)
        ELSE end_station_name END,
	end_station_id = CASE 
        WHEN LEFT(end_station_id, 1) = '"' AND RIGHT(end_station_id, 1) = '"'
        THEN SUBSTRING(end_station_id, 2, LEN(end_station_id) - 2)
        ELSE end_station_id END,
	start_lat = CASE 
        WHEN LEFT(start_lat, 1) = '"' AND RIGHT(start_lat, 1) = '"'
        THEN SUBSTRING(start_lat, 2, LEN(start_lat) - 2)
        ELSE start_lat END,
	start_lng = CASE 
        WHEN LEFT(start_lng, 1) = '"' AND RIGHT(start_lng, 1) = '"'
        THEN SUBSTRING(start_lng, 2, LEN(start_lng) - 2)
        ELSE start_lng END,
	end_lat = CASE 
        WHEN LEFT(end_lat, 1) = '"' AND RIGHT(end_lat, 1) = '"'
        THEN SUBSTRING(end_lat, 2, LEN(end_lat) - 2)
        ELSE end_lat END,
	end_lng = CASE 
        WHEN LEFT(end_lng, 1) = '"' AND RIGHT(end_lng, 1) = '"'
        THEN SUBSTRING(end_lng, 2, LEN(end_lng) - 2)
        ELSE end_lng END,
	member_casual = CASE 
        WHEN LEFT(member_casual, 1) = '"' AND RIGHT(member_casual, 1) = '"'
        THEN SUBSTRING(member_casual, 2, LEN(member_casual) - 2)
        ELSE member_casual END
WHERE ride_id LIKE '"%"'
	OR rideable_type LIKE '"%"'
	OR started_at LIKE '"%"'
	OR ended_at LIKE '"%"'
	OR start_station_name LIKE '"%"'
	OR start_station_id LIKE '"%"'
	OR end_station_name LIKE '"%"'
	OR end_station_id LIKE '"%"'
	OR start_lat LIKE '"%"'
	OR start_lng LIKE '"%"'
	OR end_lat LIKE '"%"'
	OR end_lng LIKE '"%"'
	OR member_casual LIKE '"%"';

-- rideable_type have 3 different type
SELECT DISTINCT rideable_type, COUNT(rideable_type) AS no_of_trips
FROM db_cyclistic..tripdata_2022
GROUP BY rideable_type;

-- Member casual have 2 different type
SELECT DISTINCT member_casual, COUNT(member_casual) AS no_of_trips
FROM db_cyclistic..tripdata_2022
GROUP BY member_casual;
