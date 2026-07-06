DROP VIEW int.trip_enriched CASCADE;
-------------------------------------------
----INTERMIDIATE LAYER
--------------------------------------------
     ----Create enriched trip table
CREATE OR REPLACE VIEW int.trip_enriched AS
SELECT
    t.trip_id,
    t.customer_id,
    t.driver_id,
    
	--Location
	t.pickup_location,
    t.drop_location,
    
	c.segment AS customer_segment,
    d.city AS driver_city,
    d.vehicle_type,
    d.rating,

    p.payment_type,
    p.discount,
    p.final_amount,

    t.trip_status,
    t.distance_km,
    t.fare,

    t.pickup_time,
    t.drop_time,

    -- derived metric
    EXTRACT(EPOCH FROM (t.drop_time - t.pickup_time))/60 AS trip_duration_min,

    -- revenue logic
    CASE 
        WHEN t.trip_status = 'completed'
        THEN COALESCE(p.final_amount, t.fare)
        ELSE 0
    END AS realized_revenue

FROM stg.trips t
LEFT JOIN stg.customers c
    ON t.customer_id = c.customer_id
LEFT JOIN stg.drivers d
    ON t.driver_id = d.driver_id
LEFT JOIN stg.payments p
    ON t.trip_id = p.trip_id;