------------------------------------
-----staging.payments
-------------------------------------
CREATE OR REPLACE VIEW stg.payments AS
SELECT
    trip_id,

    LOWER(TRIM(payment_type)) AS payment_type,

    COALESCE(discount,0) AS discount,

    final_amount,

    -- anomaly flag
    CASE
      WHEN discount > final_amount
      THEN 'discount_anomaly'
      ELSE 'valid'
    END AS dq_flag,

    created_at

FROM raw.payments;