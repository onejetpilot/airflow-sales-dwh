CREATE SCHEMA IF NOT EXISTS marts;

DROP TABLE IF EXISTS marts.mart_daily_sales;
DROP TABLE IF EXISTS marts.mart_customer_ltv;
DROP TABLE IF EXISTS marts.mart_product_performance;

CREATE TABLE marts.mart_daily_sales AS
SELECT
    order_date,
    COUNT(*) AS orders_count,
    SUM(quantity) AS items_sold,
    SUM(payment_amount) AS revenue
FROM core.fact_orders
WHERE payment_status = 'success'
GROUP BY order_date;

CREATE TABLE marts.mart_customer_ltv AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    r.region_name,
    COUNT(f.order_id) AS orders_count,
    SUM(f.payment_amount) AS total_revenue,
    ROUND(AVG(f.payment_amount), 2) AS avg_order_value
FROM core.fact_orders f
JOIN core.dim_customers c 
    ON f.customer_id = c.customer_id
LEFT JOIN core.dim_regions r
    ON c.region_id = r.region_id
WHERE f.payment_status = 'success'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city,
    r.region_name;

CREATE TABLE marts.mart_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(f.order_id) AS order_count,
    SUM(f.quantity) AS items_sold,
    SUM(f.payment_amount) AS revenue,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(f.payment_amount) DESC
    ) AS revenue_rank_in_category
FROM core.fact_orders f
JOIN core.dim_products p
    ON f.product_id = p.product_id
WHERE f.payment_status = 'success'
GROUP BY
    p.product_id,
    p.product_name,
    p.category;

