-------------------------------------------
------staging.customers
-------------------------------------------
CREATE OR REPLACE VIEW stg.customers AS
SELECT
    customer_id,

    signup_date,

    INITCAP(TRIM(segment)) AS segment,

    CASE
      WHEN signup_date <= CURRENT_DATE
      THEN 'valid'
      ELSE 'invalid_signup_date'
    END AS dq_flag,

    created_at

FROM raw.customers;