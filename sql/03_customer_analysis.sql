-- =====================================================
-- Advanced SQL Business Analysis
-- Customer Analysis
-- Window Functions and Ranking
-- =====================================================

-- =====================================================
-- Top customers by total spending
-- =====================================================

SELECT
    c.customer_unique_id,

    ROUND(SUM(op.payment_value), 2)
        AS total_spent

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_unique_id

ORDER BY total_spent DESC

LIMIT 10;

-- =====================================================
-- Rank customers by revenue
-- =====================================================

SELECT
    c.customer_unique_id,

    ROUND(SUM(op.payment_value), 2)
        AS total_spent,

    RANK() OVER(
        ORDER BY SUM(op.payment_value) DESC
    ) AS customer_rank

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_unique_id;

-- =====================================================
-- Dense ranking of customers
-- =====================================================

SELECT
    c.customer_unique_id,

    ROUND(SUM(op.payment_value), 2)
        AS total_spent,

    DENSE_RANK() OVER(
        ORDER BY SUM(op.payment_value) DESC
    ) AS dense_customer_rank

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_unique_id;

-- =====================================================
-- Customer purchase frequency
-- =====================================================

SELECT
    c.customer_unique_id,

    COUNT(DISTINCT o.order_id)
        AS total_orders

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id

ORDER BY total_orders DESC;

-- =====================================================
-- Average spending per customer
-- =====================================================

SELECT
    c.customer_unique_id,

    ROUND(AVG(op.payment_value), 2)
        AS average_customer_spending

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_unique_id

ORDER BY average_customer_spending DESC;

-- =====================================================
-- Running total revenue by purchase date
-- =====================================================

SELECT
    DATE(o.order_purchase_timestamp)
        AS purchase_date,

    ROUND(SUM(op.payment_value), 2)
        AS daily_revenue,

    ROUND(
        SUM(SUM(op.payment_value)) OVER(
            ORDER BY DATE(o.order_purchase_timestamp)
        ),
        2
    ) AS cumulative_revenue

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY purchase_date

ORDER BY purchase_date;

-- =====================================================
-- Monthly revenue ranking
-- =====================================================

SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS order_month,

    ROUND(SUM(op.payment_value), 2)
        AS monthly_revenue,

    RANK() OVER(
        ORDER BY SUM(op.payment_value) DESC
    ) AS revenue_rank

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY order_month;

-- =====================================================
-- Top states by revenue
-- =====================================================

SELECT
    c.customer_state,

    ROUND(SUM(op.payment_value), 2)
        AS total_revenue,

    RANK() OVER(
        ORDER BY SUM(op.payment_value) DESC
    ) AS state_rank

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_state;