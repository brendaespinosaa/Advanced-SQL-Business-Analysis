-- =====================================================
-- Advanced SQL Business Analysis
-- Business Questions Analysis
-- =====================================================

-- =====================================================
-- Which product categories generate the highest revenue?
-- =====================================================

SELECT
    p.product_category_name,

    ROUND(SUM(op.payment_value), 2)
        AS total_revenue,

    COUNT(DISTINCT o.order_id)
        AS total_orders

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

JOIN orders o
    ON oi.order_id = o.order_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY p.product_category_name

ORDER BY total_revenue DESC

LIMIT 10;

-- =====================================================
-- Which states generate the highest revenue?
-- =====================================================

SELECT
    c.customer_state,

    ROUND(SUM(op.payment_value), 2)
        AS total_revenue,

    COUNT(DISTINCT o.order_id)
        AS total_orders

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY c.customer_state

ORDER BY total_revenue DESC;

-- =====================================================
-- Monthly sales seasonality analysis
-- =====================================================

SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS order_month,

    ROUND(SUM(op.payment_value), 2)
        AS monthly_revenue,

    COUNT(DISTINCT o.order_id)
        AS total_orders

FROM orders o

JOIN order_payments op
    ON o.order_id = op.order_id

GROUP BY order_month

ORDER BY order_month;

-- =====================================================
-- Best performing months by revenue
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
-- Most used payment methods
-- =====================================================

SELECT
    payment_type,

    COUNT(*) AS total_payments,

    ROUND(SUM(payment_value), 2)
        AS total_revenue

FROM order_payments

GROUP BY payment_type

ORDER BY total_payments DESC;

-- =====================================================
-- Average freight cost by state
-- =====================================================

SELECT
    c.customer_state,

    ROUND(AVG(oi.freight_value), 2)
        AS average_freight_cost

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY c.customer_state

ORDER BY average_freight_cost DESC;

-- =====================================================
-- Top selling products by number of orders
-- =====================================================

SELECT
    p.product_category_name,

    COUNT(oi.product_id)
        AS total_products_sold

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY p.product_category_name

ORDER BY total_products_sold DESC

LIMIT 10;

-- =====================================================
-- Average delivery time
-- =====================================================

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;

-- =====================================================
-- Delivery performance by state
-- =====================================================

SELECT
    c.customer_state,

    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY average_delivery_days DESC;