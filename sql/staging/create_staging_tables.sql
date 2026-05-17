CREATE SCHEMA IF NOT EXISTS staging;

DROP TABLE IF EXISTS staging.stg_orders;
DROP TABLE IF EXISTS staging.stg_customers;
DROP TABLE IF EXISTS staging.stg_products;
DROP TABLE IF EXISTS staging.stg_payments;

CREATE TABLE staging.stg_customers (
    customer_id INTEGER,
    customer_name TEXT,
    email TEXT,
    city TEXT,
    region TEXT,
    registration_date DATE
);

CREATE TABLE staging.stg_products (
    product_id INTEGER,
    product_name TEXT,
    category TEXT,
    price NUMERIC(10, 2)
);

CREATE TABLE staging.stg_orders (
    order_id INTEGER,
    customer_id INTEGER,
    product_id INTEGER,
    order_date DATE,
    quantity INTEGER,
    order_status TEXT
    );

CREATE TABLE staging.stg_payments (
    payment_id INTEGER,
    order_id INTEGER,
    payment_date DATE,
    payment_amount NUMERIC(10, 2),
    payment_method TEXT,
    payment_status TEXT
);
