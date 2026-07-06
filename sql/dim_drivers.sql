---------------------------------------------
-----------CREATE DIEMENSION
---------------------------------------------
                 ---Drivers dimension
CREATE OR REPLACE VIEW analytics.dim_drivers AS
SELECT DISTINCT
    driver_id,
    driver_city,
    vehicle_type,
    rating
FROM int.trip_enriched;