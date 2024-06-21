
-- The orginal table structure
SELECT * 
FROM pizza_runner.customer_orders;

/*

Result:

order_id|customer_id|pizza_id|exclusions|extras|order_time             |
--------+-----------+--------+----------+------+-----------------------+
       1|        101|       1|          |      |2021-01-01 18:05:02.000|
       2|        101|       1|          |      |2021-01-01 19:00:52.000|
       3|        102|       1|          |      |2021-01-02 23:51:23.000|
       3|        102|       2|          |NaN   |2021-01-02 23:51:23.000|
       4|        103|       1|4         |      |2021-01-04 13:23:46.000|
       4|        103|       1|4         |      |2021-01-04 13:23:46.000|
       4|        103|       2|4         |      |2021-01-04 13:23:46.000|
       5|        104|       1|null      |1     |2021-01-08 21:00:29.000|
       6|        101|       2|null      |null  |2021-01-08 21:03:13.000|
       7|        105|       2|null      |1     |2021-01-08 21:20:29.000|
       8|        102|       1|null      |null  |2021-01-09 23:54:33.000|
       9|        103|       1|4         |1, 5  |2021-01-10 11:22:59.000|
      10|        104|       1|null      |null  |2021-01-11 18:34:49.000|
      10|        104|       1|2, 6      |1, 4  |2021-01-11 18:34:49.000|
      
*/

DROP TABLE IF EXISTS clean_customer_orders;
CREATE TEMP TABLE clean_customer_orders AS (
	SELECT
		order_id,
		customer_id,
		pizza_id,
		CASE
			-- Check if exclusions is either empty or has the string value 'null'
			WHEN exclusions = '' OR exclusions = 'null' OR exclusions = 'NaN' THEN NULL
			ELSE exclusions
		END AS exclusions,
		CASE
			-- Check if extras is either empty or has the string value 'null'
			WHEN extras = '' OR extras LIKE 'null' OR extras = 'NaN' THEN NULL
			ELSE extras
		END AS extras,
		order_time
	FROM
		pizza_runner.customer_orders
);
      
SELECT * 
FROM clean_customer_orders;

/*

-- Result:
	
order_id|customer_id|pizza_id|exclusions|extras|order_time             |
--------+-----------+--------+----------+------+-----------------------+
       1|        101|       1|[NULL]    |[NULL]|2021-01-01 18:05:02.000|
       2|        101|       1|[NULL]    |[NULL]|2021-01-01 19:00:52.000|
       3|        102|       1|[NULL]    |[NULL]|2021-01-02 23:51:23.000|
       3|        102|       2|[NULL]    |[NULL]|2021-01-02 23:51:23.000|
       4|        103|       1|4         |[NULL]|2021-01-04 13:23:46.000|
       4|        103|       1|4         |[NULL]|2021-01-04 13:23:46.000|
       4|        103|       2|4         |[NULL]|2021-01-04 13:23:46.000|
       5|        104|       1|[NULL]    |1     |2021-01-08 21:00:29.000|
       6|        101|       2|[NULL]    |[NULL]|2021-01-08 21:03:13.000|
       7|        105|       2|[NULL]    |1     |2021-01-08 21:20:29.000|
       8|        102|       1|[NULL]    |[NULL]|2021-01-09 23:54:33.000|
       9|        103|       1|4         |1, 5  |2021-01-10 11:22:59.000|
      10|        104|       1|[NULL]    |[NULL]|2021-01-11 18:34:49.000|
      10|        104|       1|2, 6      |1, 4  |2021-01-11 18:34:49.000|
      
*/

/*

Clean Data

The runner_order table has inconsistent data types.  We must first clean the data before answering any questions. 
The distance and duration columns have text and numbers.  
	1. We will remove the text values and convert to numeric values.
	2. We will convert all 'null' (text) and 'NaN' values in the cancellation column to null (data type).
	3. We will convert the pickup_time (varchar) column to a timestamp data type.


The orginal table consist structure

*/

SELECT * 
FROM pizza_runner.runner_orders;

/*

Result:

order_id|runner_id|pickup_time        |distance|duration  |cancellation           |
--------+---------+-------------------+--------+----------+-----------------------+
       1|        1|2021-01-01 18:15:34|20km    |32 minutes|                       |
       2|        1|2021-01-01 19:10:54|20km    |27 minutes|                       |
       3|        1|2021-01-03 00:12:37|13.4km  |20 mins   |[NULL]                 |
       4|        2|2021-01-04 13:53:03|23.4    |40        |[NULL]                 |
       5|        3|2021-01-08 21:10:57|10      |15        |[NULL]                 |
       6|        3|null               |null    |null      |Restaurant Cancellation|
       7|        2|2021-01-08 21:30:45|25km    |25mins    |null                   |
       8|        2|2021-01-10 00:15:02|23.4 km |15 minute |null                   |
       9|        2|null               |null    |null      |Customer Cancellation  |
      10|        1|2021-01-11 18:50:20|10km    |10minutes |null                   |
      
*/

DROP TABLE IF EXISTS clean_runner_orders;
CREATE TEMP TABLE clean_runner_orders AS (
	SELECT
		order_id,
		runner_id,
		CASE
			WHEN pickup_time LIKE 'null' THEN NULL
			ELSE pickup_time
		-- Cast results to timestamp
		END::TIMESTAMP AS pickup_time,
		-- Return null value if both arguments are equal
		-- Use regex to match only numeric values and decimal point.
		-- Cast to numeric datatype
		NULLIF(REGEXP_REPLACE(distance, '[^0-9.]', '', 'g'), '')::NUMERIC AS distance,
		NULLIF(REGEXP_REPLACE(duration, '[^0-9.]', '', 'g'), '')::NUMERIC AS duration,
		-- Cast to NULL datatype if string equals empty, null or Nan.
		CASE
			WHEN cancellation LIKE 'null'
				OR cancellation LIKE 'NaN' 
				OR cancellation LIKE '' THEN NULL
		ELSE cancellation
	END AS cancellation
	FROM
		pizza_runner.runner_orders
);

SELECT * 
FROM clean_runner_orders;

/*

Results:

order_id|runner_id|pickup_time            |distance|duration|cancellation           |
--------+---------+-----------------------+--------+--------+-----------------------+
       1|        1|2021-01-01 18:15:34.000|      20|      32|[NULL]                 |
       2|        1|2021-01-01 19:10:54.000|      20|      27|[NULL]                 |
       3|        1|2021-01-03 00:12:37.000|    13.4|      20|[NULL]                 |
       4|        2|2021-01-04 13:53:03.000|    23.4|      40|[NULL]                 |
       5|        3|2021-01-08 21:10:57.000|      10|      15|[NULL]                 |
       6|        3|                 [NULL]|  [NULL]|  [NULL]|Restaurant Cancellation|
       7|        2|2021-01-08 21:30:45.000|      25|      25|[NULL]                 |
       8|        2|2021-01-10 00:15:02.000|    23.4|      15|[NULL]                 |
       9|        2|                 [NULL]|  [NULL]|  [NULL]|Customer Cancellation  |
      10|        1|2021-01-11 18:50:20.000|      10|      10|[NULL]                 |
      
*/

/*************************************
 * Questions....
**************************************/

-- How many pizzas were ordered?
      
SELECT
	COUNT(*) AS number_of_orders
FROM
	clean_customer_orders;

/*

Results:

number_of_orders|
----------------+
              14|
      
*/

-- 2. How many unique customer orders were made?
   
SELECT
	COUNT(DISTINCT order_id) AS unique_orders
FROM
	clean_customer_orders;

/*

unique_orders|
-------------+
           10|      
*/
      
-- How many successful orders were delivered by each runner?

SELECT
	runner_id,
	COUNT(order_id) AS successful_orders
FROM
	clean_runner_orders
WHERE
	cancellation IS NULL
GROUP BY
	runner_id
ORDER BY
	successful_orders DESC;

/*

runner_id|successful_orders|
---------+-----------------+
        1|                4|
        2|                3|
        3|                1|  
            
*/
        
-- How many of each type of pizza was delivered?
        
SELECT
	t2.pizza_name,
	COUNT(t1.*) AS delivery_count
FROM
	clean_customer_orders AS t1
JOIN 
	pizza_names AS t2
ON
	t2.pizza_id = t1.pizza_id
JOIN 
	clean_runner_orders AS t3
ON
	t1.order_id = t3.order_id
WHERE
	cancellation IS NULL
GROUP BY
	t2.pizza_name
ORDER BY
	delivery_count DESC;

/*

pizza_name|delivery_count|
----------+--------------+
Meatlovers|             9|
Vegetarian|             3|  
            
*/      
        
        
--  How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
	customer_id,
	SUM(
		CASE
			WHEN pizza_id = 1 THEN 1 
			ELSE 0
		END
	) AS meat_lovers,
	SUM(
		CASE
			WHEN pizza_id = 2 THEN 1 
			ELSE 0
		END
	) AS vegetarian
FROM
	clean_customer_orders
GROUP BY
	customer_id
ORDER BY 
	customer_id;

/*

customer_id|meat_lovers|vegetarian|
-----------+-----------+----------+
        101|          2|         1|
        102|          2|         1|
        103|          3|         1|
        104|          3|         0|
        105|          0|         1|  
            
*/
        
        
-- What was the maximum number of pizzas delivered in a single order?       
        
WITH order_count_cte AS (
	SELECT	
		t1.order_id,
		COUNT(t1.pizza_id) AS n_orders
	FROM 
		clean_customer_orders AS t1
	JOIN 
		clean_runner_orders AS t2
	ON 
		t1.order_id = t2.order_id
	WHERE
		t2.cancellation IS NULL
	GROUP BY 
		t1.order_id
)
SELECT
	MAX(n_orders) AS max_delivered_pizzas
FROM order_count_cte;

/*

max_delivered_pizzas|
--------------------+
                   3|  
            
*/
           
-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT
	t1.customer_id,
	SUM(
		CASE
			WHEN t1.exclusions IS NOT NULL OR t1.extras IS NOT NULL THEN 1
			ELSE 0
		END
	) AS with_changes,
	SUM(
		CASE
			WHEN t1.exclusions IS NULL AND t1.extras IS NULL THEN 1
			ELSE 0
		END
	) AS no_changes
FROM
	clean_customer_orders AS t1
JOIN 
	clean_runner_orders AS t2
ON 
	t1.order_id = t2.order_id
WHERE
	t2.cancellation IS NULL
GROUP BY
	t1.customer_id
ORDER BY
	t1.customer_id;
        
/*

customer_id|with_changes|no_changes|
-----------+------------+----------+
        101|           0|         2|
        102|           0|         3|
        103|           3|         0|
        104|           2|         1|
        105|           1|         0|  
            
*/
        
-- How many pizzas were delivered that had both exclusions and extras?
        
SELECT
	SUM(
		CASE
			WHEN t1.exclusions IS NOT NULL AND t1.extras IS NOT NULL THEN 1
			ELSE 0
		END
	) AS number_of_pizzas
FROM 
	clean_customer_orders AS t1
JOIN 
	clean_runner_orders AS t2
ON 
	t1.order_id = t2.order_id
WHERE 
	t2.cancellation IS NULL;

/*

number_of_pizzas|
----------------+
               1|  
            
*/      
        
-- What was the total volume of pizzas ordered for each hour of the day?

SELECT
	-- Cast to TEXT to remove .0
	EXTRACT('hour' FROM order_time::TIMESTAMP)::TEXT AS hour_of_day_24h,
	-- Adding the 12 hour time format
	TO_CHAR(order_time::TIMESTAMP, 'HH:AM') AS hour_of_day_12h,
	COUNT(*) AS number_of_pizzas
FROM 
	clean_customer_orders
WHERE 
	order_time IS NOT NULL
GROUP BY 
	hour_of_day_24h,
	hour_of_day_12h
ORDER BY 
	hour_of_day_24h;

/*

hour_of_day_24h|hour_of_day_12h|number_of_pizzas|
---------------+---------------+----------------+
11             |11:AM          |               1|
13             |01:PM          |               3|
18             |06:PM          |               3|
19             |07:PM          |               1|
21             |09:PM          |               3|
23             |11:PM          |               3|  
            
*/
       
-- What was the volume of orders for each day of the week?

SELECT
	TO_CHAR(order_time, 'Day') AS day_of_week,
	COUNT(*) AS number_of_pizzas
FROM 
	clean_customer_orders
GROUP BY 
	day_of_week,
	EXTRACT('dow' FROM order_time)
ORDER BY 
	EXTRACT('dow' FROM order_time);

/*

day_of_week|number_of_pizzas|
-----------+----------------+
Sunday     |               1|
Monday     |               5|
Friday     |               5|
Saturday   |               3|  
            
*/

-- What was the average distance traveled for each customer?

WITH get_distances AS (
	SELECT
		t2.customer_id,
		t2.order_id,
		t1.distance
	FROM 
		clean_runner_orders AS t1
	JOIN
		clean_customer_orders AS t2
	ON 
		t2.order_id = t1.order_id
	WHERE
		t1.distance IS NOT NULL
	GROUP BY 
		t2.customer_id,
		t1.distance,
		t2.order_id
	ORDER BY 
		t2.customer_id
)
SELECT
	customer_id,
	ROUND(AVG(distance), 2) AS avg_distance
FROM
	get_distances
GROUP BY
	customer_id;

/*

customer_id|avg_distance|
-----------+------------+
        101|       20.00|
        102|       18.40|
        103|       23.40|
        104|       10.00|
        105|       25.00|

*/

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH runner_time AS (
	SELECT DISTINCT
		t1.order_id,
		(t1.pickup_time - t2.order_time) AS runner_arrival_time
	FROM 
		clean_runner_orders AS t1
	JOIN 
		clean_customer_orders AS t2
	ON 
		t1.order_id = t2.order_id
	WHERE
		t1.pickup_time IS NOT NULL
)
SELECT
	EXTRACT('minutes' FROM AVG(runner_arrival_time)) AS avg_pickup_time
FROM
	runner_time;
	
/*

avg_pickup_time|
---------------+
             15|  
            
*/  
   






         
         
         
         
