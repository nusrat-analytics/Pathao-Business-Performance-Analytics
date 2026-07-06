-------------------------------------------
---RAW DATA LAYER SCHEMA DESIGN
--------------------------------------------
--Raw table trips
CREATE TABLE raw.trips (
    trip_id            VARCHAR(50) PRIMARY KEY,

    customer_id        VARCHAR(50),
    driver_id          VARCHAR(50),

    request_time       TIMESTAMP,
    pickup_time        TIMESTAMP,
    drop_time          TIMESTAMP,

    pickup_location    TEXT,
    drop_location      TEXT,

    distance_km        NUMERIC(6,2),
    fare               NUMERIC(10,2),

    trip_status        VARCHAR(20),

    -- metadata
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT*FROM raw.trips
--Raw table drivers
CREATE TABLE raw.drivers (
    driver_id        VARCHAR(50) PRIMARY KEY,

    rating           NUMERIC(2,1),     -- e.g., 4.5
    join_date        DATE,
    city             VARCHAR(50),
	vehicle_type     VARCHAR(20),      -- bike / car
    
    -- metadata
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT*FROM raw.drivers

--Raw table customers
CREATE TABLE raw.customers (
    customer_id      VARCHAR(50) PRIMARY KEY,
    signup_date      DATE,
	segment          TEXT,

    -- metadata
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT*FROM raw.customers

--RAW table payments
CREATE TABLE raw.payments (
    trip_id          VARCHAR(50),

    payment_type     VARCHAR(20),   -- cash / card / wallet
    discount         NUMERIC(10,2),
    final_amount     NUMERIC(10,2),

    -- metadata
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SELECT*FROM raw.payments

--DATA PROFILLING CHECKLIST👀
------------------------------------------
-----DATA PROFILLING(raw.trips)
-------------------------------------------
-- 1. Row count
SELECT COUNT(*) AS total_rows
FROM raw.trips;


-- 2. Duplicate primary keys
SELECT trip_id, COUNT(*)
FROM raw.trips
GROUP BY trip_id
HAVING COUNT(*) > 1;


-- 3. Null checks
SELECT
COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer,
COUNT(*) FILTER (WHERE driver_id IS NULL) AS null_driver,
COUNT(*) FILTER (WHERE request_time IS NULL) AS null_request_time
FROM raw.trips;


-- 4. Categorical profiling
SELECT trip_status, COUNT(*)
FROM raw.trips
GROUP BY trip_status
ORDER BY COUNT(*) DESC;


-- 5. Numeric ranges
SELECT
MIN(fare),
MAX(fare),
AVG(fare),
MIN(distance_km),
MAX(distance_km)
FROM raw.trips;


-- 6. Invalid numeric values
SELECT *
FROM raw.trips
WHERE fare < 0
OR distance_km < 0;


-- 7. Timestamp validation
SELECT *
FROM raw.trips
WHERE drop_time < pickup_time;


-- 8. Outlier check
SELECT *
FROM raw.trips
WHERE EXTRACT(EPOCH FROM(drop_time-pickup_time))/60 > 300;


-- 9. Distribution check
SELECT
trip_status,
COUNT(*)*100.0/SUM(COUNT(*)) OVER() pct
FROM raw.trips
GROUP BY trip_status;

--------------------------------------
------DATA PROFILLING(drivers)
-- 1. Row count
SELECT COUNT(*)
FROM raw.drivers;


-- 2. Duplicate PK
SELECT driver_id, COUNT(*)
FROM raw.drivers
GROUP BY driver_id
HAVING COUNT(*) >1;


-- 3. Null checks
SELECT
COUNT(*) FILTER (WHERE rating IS NULL) AS null_rating,
COUNT(*) FILTER (WHERE city IS NULL) AS null_city
FROM raw.drivers;


-- 4. Category profiling
SELECT vehicle_type, COUNT(*)
FROM raw.drivers
GROUP BY vehicle_type;


-- 5. Rating validity
SELECT *
FROM raw.drivers
WHERE rating NOT BETWEEN 1 AND 5;


-- 6. Future join dates
SELECT *
FROM raw.drivers
WHERE join_date > CURRENT_DATE;

---------------------------------------------------
------DATA PROFILLING(customers)
---------------------------------------------------

-- 1. Row count
SELECT COUNT(*)
FROM raw.customers;


-- 2. Duplicate PK
SELECT customer_id, COUNT(*)
FROM raw.customers
GROUP BY customer_id
HAVING COUNT(*) >1;


-- 3. Null checks
SELECT
COUNT(*) FILTER (WHERE signup_date IS NULL) AS null_signup,
COUNT(*) FILTER (WHERE segment IS NULL) AS null_segment
FROM raw.customers;


-- 4. Segment profiling
SELECT segment, COUNT(*)
FROM raw.customers
GROUP BY segment;


-- 5. Invalid signup dates
SELECT *
FROM raw.customers
WHERE signup_date > CURRENT_DATE;

--------------------------------------------
------DATA PROFILLING(raw.payment)
--------------------------------------------
-- 1. Row count
SELECT COUNT(*)
FROM raw.payments;


-- 2. Duplicate payments per trip
SELECT trip_id, COUNT(*)
FROM raw.payments
GROUP BY trip_id
HAVING COUNT(*) >1;


-- 3. Null checks
SELECT
COUNT(*) FILTER (WHERE payment_type IS NULL) AS null_payment_type,
COUNT(*) FILTER (WHERE final_amount IS NULL) AS null_amount
FROM raw.payments;


-- 4. Payment type profiling
SELECT payment_type, COUNT(*)
FROM raw.payments
GROUP BY payment_type;


-- 5. Invalid discount logic
SELECT *
FROM raw.payments
WHERE discount > final_amount;

---------------------------------------
-----REFERENTIAL INTEGRITY CHECK
---------------------------------------
-- Completed trips without payments
SELECT t.trip_id
FROM raw.trips t
LEFT JOIN raw.payments p
ON t.trip_id = p.trip_id
WHERE t.trip_status='completed'
AND p.trip_id IS NULL;

-- Trips with missing customers
SELECT t.trip_id
FROM raw.trips t
LEFT JOIN raw.customers c
ON t.customer_id=c.customer_id
WHERE c.customer_id IS NULL;

-- Trips with missing drivers
SELECT t.trip_id
FROM raw.trips t
LEFT JOIN raw.drivers d
ON t.driver_id=d.driver_id
WHERE d.driver_id IS NULL;