-------------------------------------------
----staging.trips
-------------------------------------------
CREATE OR REPLACE VIEW stg.trips AS
SELECT
    trip_id,
    customer_id,
    driver_id,

    -- Standardize status
    CASE
        WHEN LOWER(TRIM(trip_status)) IN ('completed','complete')
            THEN 'completed'
        WHEN LOWER(TRIM(trip_status)) IN ('cancelled','canceled')
            THEN 'cancelled'
        ELSE 'unknown'
    END AS trip_status,

    request_time,

    -- Impute missing pickup timestamps
    COALESCE(pickup_time, request_time) AS pickup_time,

    drop_time,

    -- Standardize text fields
    INITCAP(TRIM(pickup_location)) AS pickup_location,
    INITCAP(TRIM(drop_location)) AS drop_location,

    distance_km,
    fare,

    -- Derived feature
    EXTRACT(EPOCH FROM (
        drop_time - COALESCE(pickup_time,request_time)
    ))/60 AS trip_duration_min,

    -- Data quality flag
    CASE
      WHEN fare <0 OR distance_km <0 THEN 'invalid_numeric'
      WHEN drop_time < pickup_time THEN 'invalid_timestamp'
      ELSE 'valid'
    END AS dq_flag,

    created_at

FROM raw.trips;