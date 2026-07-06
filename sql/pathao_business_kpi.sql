--------------------------------------------
----Business KPI LAYER(analytics)
--------------------------------------------
         ----1.Total Revenue

SELECT SUM(realized_revenue) AS total_revenue
FROM analytics.fact_trips;

        
	    ----2.Trips by Status
		
SELECT trip_status, COUNT(*)
FROM analytics.fact_trips
GROUP BY trip_status;

        ----3.Revenue by Drive
		r
SELECT driver_id, SUM(realized_revenue) AS revenue
FROM analytics.fact_trips
GROUP BY driver_id
ORDER BY revenue DESC;

        ----4.Driver Revenue Ranking
WITH driver_perf AS (
SELECT
driver_id,
SUM(realized_revenue) revenue,
COUNT(*) trips_completed
FROM analytics.fact_trips
WHERE trip_status='completed'
GROUP BY driver_id
)

SELECT *,
RANK() OVER(ORDER BY revenue DESC) revenue_rank
FROM driver_perf;

       ----5.Driver Utilization Efficiency
SELECT
driver_id,
COUNT(*) trips,
AVG(trip_duration_min) avg_duration,
SUM(realized_revenue)/COUNT(*) revenue_per_trip
FROM analytics.fact_trips
GROUP BY driver_id;
     
	 ----6.Peak Hour Demand Analysis
SELECT
EXTRACT(HOUR FROM pickup_time) hour,
COUNT(*) trips,
SUM(realized_revenue) revenue
FROM analytics.fact_trips
GROUP BY hour
ORDER BY hour;
    ----7.Cancellation Rate by Vehicle Type
SELECT
vehicle_type,
COUNT(*) total_trips,
SUM(
CASE WHEN trip_status='cancelled'
THEN 1 ELSE 0 END
) cancellations,
ROUND(
100.0*
SUM(CASE WHEN trip_status='cancelled' THEN 1 ELSE 0 END)
/COUNT(*),2
) cancel_rate
FROM analytics.fact_trips
GROUP BY vehicle_type;
     ----8.Customer Lifetime Value (Simple CLV)
WITH customer_value AS(
SELECT
customer_id,
COUNT(*) trips,
SUM(realized_revenue) lifetime_value
FROM analytics.fact_trips
GROUP BY customer_id
)

SELECT *,
NTILE(4) OVER(
ORDER BY lifetime_value DESC
) customer_tier
FROM customer_value;
     ----9.Repeat Rider Retention
WITH cust AS (
SELECT
customer_id,
COUNT(*) trips
FROM analytics.fact_trips
GROUP BY customer_id
)

SELECT
COUNT(*) customers,
SUM(
CASE WHEN trips>1
THEN 1 ELSE 0 END
) repeat_customers
FROM cust;
     ----10.Rolling Revenue Trend (Window Function)
SELECT
DATE(request_time) dt,
SUM(realized_revenue) daily_revenue,

SUM(SUM(realized_revenue))
OVER(
ORDER BY DATE(request_time)
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) rolling_7day_revenue

FROM analytics.fact_trips
GROUP BY dt
ORDER BY dt;
     ----11.Driver Revenue Concentration (Pareto 80/20)
WITH rev AS (
SELECT
driver_id,
SUM(realized_revenue) revenue
FROM analytics.fact_trips
GROUP BY driver_id
)

SELECT *,
SUM(revenue)
OVER(ORDER BY revenue DESC)
AS cumulative_revenue
FROM rev;
    ----12.Ride Completion Funnel
WITH funnel AS (
SELECT 'Requested' stage, COUNT(*) volume
FROM analytics.fact_trips

UNION ALL

SELECT 'Completed',
COUNT(*)
FROM analytics.fact_trips
WHERE trip_status='completed'

UNION ALL

SELECT 'Cancelled',
COUNT(*)
FROM analytics.fact_trips
WHERE trip_status='cancelled'
)

SELECT *
FROM funnel;
     ----13.Supply-Demand Pressure
WITH hourly_demand AS(
SELECT
EXTRACT(HOUR FROM pickup_time) hr,
COUNT(*) trips,
COUNT(DISTINCT driver_id) active_drivers
FROM analytics.fact_trips
GROUP BY hr
)

SELECT
hr,
trips,
active_drivers,
ROUND(
trips::numeric/
NULLIF(active_drivers,0),2
) AS trips_per_driver
FROM hourly_demand
ORDER BY hr;
     ----14.Driver Productivity / Idle Proxy
SELECT
driver_id,
COUNT(*) total_trips,
SUM(realized_revenue) total_revenue,
AVG(trip_duration_min) avg_duration,

ROUND(
SUM(realized_revenue)/COUNT(*),2
) revenue_per_trip

FROM analytics.fact_trips
GROUP BY driver_id
ORDER BY total_trips DESC;
     ----15.Location Demand Hotspots
SELECT
pickup_location,
COUNT(*) trips,
SUM(realized_revenue) revenue
FROM analytics.fact_trips
GROUP BY pickup_location
ORDER BY trips DESC;                     

SELECT            ----15.1 Origin Destination
pickup_location,
drop_location,
COUNT(*) route_volume
FROM analytics.fact_trips
GROUP BY 1,2

     ----16.Average Revenue per KM (Unit Economics)

SELECT
CASE
 WHEN distance_km < 5 THEN 'Short'
 WHEN distance_km < 10 THEN 'Medium'
 ELSE 'Long'
END AS trip_distance_category,

AVG(realized_revenue) AS avg_revenue,

AVG(
realized_revenue/NULLIF(distance_km,0)
) AS revenue_per_km

FROM analytics.fact_trips
WHERE trip_status='completed'
GROUP BY 1;
      
	  ----17.Demand spikes
WITH hourly AS(
SELECT
EXTRACT(HOUR FROM pickup_time) hr,
COUNT(*) trips
FROM analytics.fact_trips
GROUP BY hr
)

SELECT *,
AVG(trips) OVER() avg_hourly_trips,
CASE
WHEN trips >
1.5*AVG(trips) OVER()
THEN 'surge_like_hour'
ELSE 'normal'
END demand_flag
FROM hourly;