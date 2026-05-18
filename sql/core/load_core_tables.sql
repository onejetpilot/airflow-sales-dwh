TRUNCATE TABLE core.fact_orders;
TRUNCATE TABLE core.dim_customers CASCADE;
TRUNCATE TABLE core.dim_products CASCADE;
TRUNCATE TABLE core.dim_regions CASCADE;

INSERT INTO core.dim_regions (region_name)
SELECT DISTINCT region
FROM staging.stg_customers
WHERE region IS NOT NULL;

INSERT INTO core.dim_customers (
    customer_id,
    customer_name,
    email,
    city,
    region_id,
    registration_date
)
SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    r.region_id,
    c.registration_date
FROM staging.stg_customers c
LEFT JOIN core.dim_regions r
    ON c.region = r.region_name;

INSERT INTO core.dim_products (
    product_id,
    product_name,
    category,
    price
)
SELECT
    product_id,
    product_name,
    category,
    price
FROM staging.stg_products;

INSERT INTO core.fact_orders (
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    order_status,
    payment_id,
    payment_date,
    payment_amount,
    payment_method,
    payment_status
)
SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.quantity,
    o.order_status,
    p.payment_id,
    p.payment_date,
    p.payment_amount,
    p.payment_method,
    p.payment_status
FROM staging.stg_orders o
LEFT JOIN staging.stg_payments p
    ON o.order_id = p.order_id;




