--Динамика выручки по дням
SELECT
    order_date,
    revenue,
    SUM(revenue) OVER (
        ORDER BY order_date,
    ) AS cumulative_revenue
FROM marts.mart_daily_sales
ORDER BY order_date;

--Топ клиентов по LTV
SELECT
    customer_id,
    customer_name,
    city,
    region_name,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC) AS ltv_rank
FROM marts.mart_customer_ltv
ORDER BY total_revenue DESC
LIMIT 10;

--Лучшие товары внутри категории
SELECT
    product_id,
    product_name,
    category,
    revenue,
    revenue_rank_in_category
FROM marts.mart_product_performance
WHERE revenue_rank_in_catefory <= 3
ORDER BY category, revenue_rank_in_category;

--Клиенты выше среднего LTV
WITH avg_ltv AS (
    SELECT
        AVG(total_revenue) AS avg_total_revenue)
SELECT
    customer_id,
    customer_name,
    total_revenue
FROM marts.mart_customer_ltv
WHERE total_revenue > (
    SELECT
        avg_total_revenue
    FROM avg_ltv)
ORDER BY total_revenue DESC;
