-----------------------------------------
----CREATE FACT TABLE(analytics layer)
-----------------------------------------
             ----Fact trips
CREATE OR REPLACE VIEW analytics.fact_trips AS
SELECT *
FROM int.trip_enriched;

DROP VIEW IF EXISTS analytics.fact_trips;