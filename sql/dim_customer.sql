-----------------------------------------------
--------CREATE DIMENSIONS
------------------------------------------------
            ---Customer Diemension
CREATE OR REPLACE VIEW analytics.dim_customers AS
SELECT DISTINCT
    customer_id,
    customer_segment
FROM int.trip_enriched;