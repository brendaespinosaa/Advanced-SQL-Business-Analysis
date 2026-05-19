-- =====================================================
-- Advanced SQL Business Analysis
-- Cohort Analysis
-- Customer Retention
-- =====================================================

-- =====================================================
-- Identify customer first purchase month
-- =====================================================

WITH first_purchase AS (

    SELECT
        customer_id,

        MIN(
            DATE_FORMAT(
                order_purchase_timestamp,
                '%Y-%m'
            )
        ) AS cohort_month

    FROM orders

    GROUP BY customer_id
)

SELECT *
FROM first_purchase;

-- =====================================================
-- Create customer cohorts
-- =====================================================

WITH first_purchase AS (

    SELECT
        customer_id,

        MIN(
            DATE_FORMAT(
                order_purchase_timestamp,
                '%Y-%m'
            )
        ) AS cohort_month

    FROM orders

    GROUP BY customer_id
),

customer_orders AS (

    SELECT
        o.customer_id,

        fp.cohort_month,

        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        ) AS order_month

    FROM orders o

    JOIN first_purchase fp
        ON o.customer_id = fp.customer_id
)

SELECT *
FROM customer_orders;

-- =====================================================
-- Calculate retention by cohort
-- =====================================================

WITH first_purchase AS (

    SELECT
        customer_id,

        MIN(
            DATE_FORMAT(
                order_purchase_timestamp,
                '%Y-%m'
            )
        ) AS cohort_month

    FROM orders

    GROUP BY customer_id
),

customer_orders AS (

    SELECT
        o.customer_id,

        fp.cohort_month,

        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        ) AS order_month

    FROM orders o

    JOIN first_purchase fp
        ON o.customer_id = fp.customer_id
),

cohort_data AS (

    SELECT
        cohort_month,

        order_month,

        COUNT(DISTINCT customer_id)
            AS total_customers

    FROM customer_orders

    GROUP BY cohort_month, order_month
)

SELECT
    cohort_month,

    order_month,

    total_customers

FROM cohort_data

ORDER BY cohort_month, order_month;