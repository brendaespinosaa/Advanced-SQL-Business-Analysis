-- =====================================================
-- Advanced SQL Business Analysis
-- Lifetime Value and Churn Analysis
-- =====================================================

-- =====================================================
-- Customer Lifetime Value (LTV)
-- =====================================================

SELECT
    c.customer_unique_id,

    COUNT(DISTINCT o.order_id)
        AS total_orders,

    ROUND(SUM(op.payment_value), 2)
        AS lifetime_value,

    ROUND(AVG(op.payment_value), 2)
        AS average_order_value

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_unique_id

ORDER BY lifetime_value DESC;

-- =====================================================
-- Top 20 customers by lifetime value
-- =====================================================

SELECT
    c.customer_unique_id,

    ROUND(SUM(op.payment_value), 2)
        AS lifetime_value,

    RANK() OVER(
        ORDER BY SUM(op.payment_value) DESC
    ) AS customer_rank

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_unique_id

LIMIT 20;

-- =====================================================
-- Churn risk analysis
-- =====================================================

WITH customer_activity AS (

    SELECT
        c.customer_unique_id,

        MAX(o.order_purchase_timestamp)
            AS last_purchase_date,

        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_purchase_timestamp)
        ) AS inactive_days,

        COUNT(DISTINCT o.order_id)
            AS total_orders,

        ROUND(SUM(op.payment_value), 2)
            AS total_spent

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,

    inactive_days,

    total_orders,

    total_spent,

    CASE

        WHEN inactive_days > 180
            THEN 'High Churn Risk'

        WHEN inactive_days > 90
            THEN 'Medium Churn Risk'

        ELSE 'Low Churn Risk'

    END AS churn_risk

FROM customer_activity

ORDER BY inactive_days DESC;

-- =====================================================
-- Count customers by churn risk
-- =====================================================

WITH customer_activity AS (

    SELECT
        c.customer_unique_id,

        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_purchase_timestamp)
        ) AS inactive_days

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    GROUP BY c.customer_unique_id
)

SELECT

    CASE

        WHEN inactive_days > 180
            THEN 'High Churn Risk'

        WHEN inactive_days > 90
            THEN 'Medium Churn Risk'

        ELSE 'Low Churn Risk'

    END AS churn_risk,

    COUNT(*) AS total_customers

FROM customer_activity

GROUP BY churn_risk

ORDER BY total_customers DESC;

-- =====================================================
-- Average lifetime value by customer frequency
-- =====================================================

WITH customer_ltv AS (

    SELECT
        c.customer_unique_id,

        COUNT(DISTINCT o.order_id)
            AS total_orders,

        ROUND(SUM(op.payment_value), 2)
            AS lifetime_value

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    total_orders,

    ROUND(AVG(lifetime_value), 2)
        AS average_ltv,

    COUNT(*) AS total_customers

FROM customer_ltv

GROUP BY total_orders

ORDER BY total_orders;