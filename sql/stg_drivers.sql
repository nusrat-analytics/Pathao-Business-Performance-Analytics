----------------------------------------
-----staging.drivers
-----------------------------------------
CREATE OR REPLACE VIEW stg.drivers AS
SELECT
    driver_id,

    rating,

    join_date,

    INITCAP(TRIM(city)) AS city,

    LOWER(TRIM(vehicle_type)) AS vehicle_type,

    CASE
      WHEN rating BETWEEN 1 AND 5
      THEN 'valid'
      ELSE 'invalid_rating'
    END AS dq_flag,

    created_at

FROM raw.drivers;