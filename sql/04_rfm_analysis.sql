-- =====================================================
-- Advanced SQL Business Analysis
-- RFM Analysis
-- Customer Segmentation
-- =====================================================

-- =====================================================
-- Calculate RFM metrics
-- =====================================================

WITH customer_rfm AS (

    SELECT
        c.customer_unique_id,

        MAX(o.order_purchase_timestamp)
            AS last_purchase_date,

        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_purchase_timestamp)
        ) AS recency,

        COUNT(DISTINCT o.order_id)
            AS frequency,

        ROUND(SUM(op.payment_value), 2)
            AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
)

SELECT *
FROM customer_rfm
ORDER BY monetary DESC;

-- =====================================================
-- Customer segmentation based on RFM
-- =====================================================

WITH customer_rfm AS (

    SELECT
        c.customer_unique_id,

        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_purchase_timestamp)
        ) AS recency,

        COUNT(DISTINCT o.order_id)
            AS frequency,

        ROUND(SUM(op.payment_value), 2)
            AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,

    recency,

    frequency,

    monetary,

    CASE

        WHEN recency <= 30
            AND frequency >= 5
            AND monetary >= 500
            THEN 'VIP Customer'

        WHEN recency <= 60
            AND frequency >= 3
            THEN 'Loyal Customer'

        WHEN recency > 180
            THEN 'At Risk Customer'

        WHEN frequency = 1
            THEN 'New Customer'

        ELSE 'Regular Customer'

    END AS customer_segment

FROM customer_rfm

ORDER BY monetary DESC;

-- =====================================================
-- Count customers by segment
-- =====================================================

WITH customer_rfm AS (

    SELECT
        c.customer_unique_id,

        DATEDIFF(
            CURRENT_DATE,
            MAX(o.order_purchase_timestamp)
        ) AS recency,

        COUNT(DISTINCT o.order_id)
            AS frequency,

        ROUND(SUM(op.payment_value), 2)
            AS monetary

    FROM customers c

    JOIN orders o
        ON c.customer_id = o.customer_id

    JOIN order_payments op
        ON o.order_id = op.order_id

    GROUP BY c.customer_unique_id
),

customer_segments AS (

    SELECT
        customer_unique_id,

        CASE

            WHEN recency <= 30
                AND frequency >= 5
                AND monetary >= 500
                THEN 'VIP Customer'

            WHEN recency <= 60
                AND frequency >= 3
                THEN 'Loyal Customer'

            WHEN recency > 180
                THEN 'At Risk Customer'

            WHEN frequency = 1
                THEN 'New Customer'

            ELSE 'Regular Customer'

        END AS customer_segment

    FROM customer_rfm
)

SELECT
    customer_segment,

    COUNT(*) AS total_customers

FROM customer_segments

GROUP BY customer_segment

ORDER BY total_customers DESC;