----------------------------------------
-----VALIDATION QUERIES
----------------------------------------    
      ---Confirm status standarized
SELECT trip_status, COUNT(*)
FROM stg.trips
GROUP BY trip_status;

      ---Review payment anomalies
SELECT *
FROM stg.payments
WHERE dq_flag='discount_anomaly';

      ---Review any flagged records
SELECT *
FROM stg.trips
WHERE dq_flag<>'valid';

SELECT COUNT(*) FROM stg.trips;
SELECT COUNT(*) FROM stg.trips WHERE dq_flag <> 'valid';