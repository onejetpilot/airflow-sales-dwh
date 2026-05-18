--Заказы без клиента
SELECT 
    COUNT(*) AS orders_without_customer
FROM core.fact_orders f
LEFT JOIN core.dim_customers c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Заказы без товара
SELECT 
    COUNT(*) AS orders_without_product
FROM core.fact_orders f
LEFT JOIN core.dim_products p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

--Заказы с отрицательной или нулевой суммой платежа
SELECT 
    COUNT(*) AS invalid_payment_amount
FROM core.fact_orders
WHERE payment_amount <= 0;

--Дубли заказов
SELECT 
    order_id,
    COUNT(*) AS duplicate_count
FROM core.fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--Пустые email клиентов
SELECT
    COUNT(*) AS customers_without_email
FROM core.dim_customers
WHERE email IS NULL OR email = '';



