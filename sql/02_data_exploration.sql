-- =====================================================
-- Advanced SQL Business Analysis
-- Data Exploration
-- =====================================================

-- =====================================================
-- Total number of customers
-- =====================================================

SELECT
    COUNT(*) AS total_customers
FROM customers;

-- =====================================================
-- Total number of orders
-- =====================================================

SELECT
    COUNT(*) AS total_orders
FROM orders;

-- =====================================================
-- Total revenue generated
-- =====================================================

SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM order_payments;

-- =====================================================
-- Average order value
-- =====================================================

SELECT
    ROUND(AVG(payment_value), 2) AS average_order_value
FROM order_payments;

-- =====================================================
-- Top states by number of customers
-- =====================================================

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

-- =====================================================
-- Top payment methods
-- =====================================================

SELECT
    payment_type,
    COUNT(*) AS total_payments
FROM order_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- =====================================================
-- Order status distribution
-- =====================================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- =====================================================
-- Monthly sales trend
-- =====================================================

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,

    ROUND(SUM(payment_value), 2) AS monthly_revenue

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY order_month

ORDER BY order_month;

-- =====================================================
-- Top 10 customers by total spending
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