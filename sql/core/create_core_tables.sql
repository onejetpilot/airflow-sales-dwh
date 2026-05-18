CREATE SCHEMA IF NOT EXISTS core;

DROP TABLE IF EXISTS core.fact_orders;
DROP TABLE IF EXISTS core.dim_customers;
DROP TABLE IF EXISTS core.dim_products;
DROP TABLE IF EXISTS core.dim_regions;

CREATE TABLE core.dim_regions (
    region_id SERIAL PRIMARY KEY,
    region_name TEXT UNIQUE
);

CREATE TABLE core.dim_customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT,
    email TEXT,
    city TEXT,
    region_id INTEGER REFERENCES core.dim_regions(region_id),
    registration_date DATE
);

CREATE TABLE core.dim_products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    price NUMERIC(10, 2)
);

CREATE TABLE core.fact_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER REFERENCES core.dim_customers(customer_id),
    product_id INTEGER REFERENCES core.dim_products(product_id),
    order_date DATE,
    quantity INTEGER,
    order_status TEXT,
    payment_id INTEGER,
    payment_date DATE,
    payment_amount NUMERIC(10, 2),
    payment_method TEXT,
    payment_status TEXT
);