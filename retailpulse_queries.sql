CREATE DATABASE IF NOT EXISTS retailpulse;
USE retailpulse;

CREATE TABLE IF NOT EXISTS sales (
    row_id              INT,
    order_id            VARCHAR(20),
    order_date          DATE,
    ship_date           DATE,
    ship_mode           VARCHAR(50),
    customer_id         VARCHAR(20),
    customer_name       VARCHAR(100),
    segment             VARCHAR(50),
    country             VARCHAR(50),
    city                VARCHAR(100),
    state               VARCHAR(100),
    postal_code         VARCHAR(10),
    region              VARCHAR(20),
    product_id          VARCHAR(20),
    category            VARCHAR(50),
    sub_category        VARCHAR(50),
    product_name        VARCHAR(255),
    sales               DECIMAL(10,4),
    quantity            INT,
    discount            DECIMAL(5,4),
    profit              DECIMAL(10,4),
    order_year          INT,
    order_month         INT,
    order_quarter       INT,
    order_month_name    VARCHAR(10),
    ship_duration_days  INT,
    revenue             DECIMAL(10,2),
    cost                DECIMAL(10,2),
    profit_margin       DECIMAL(10,2),
    discounted_flag     TINYINT,
    revenue_band        VARCHAR(20)
);

SHOW VARIABLES LIKE 'secure_file_priv';

-- Clear the table before loading so the script can be rerun without duplicating rows
TRUNCATE TABLE sales;

-- Reload once
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/superstore_cleaned.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(row_id, order_id, @order_date, @ship_date, ship_mode, customer_id,
 customer_name, segment, country, city, state, postal_code, region,
 product_id, category, sub_category, product_name, sales, quantity,
 discount, profit, order_year, order_month, order_quarter,
 order_month_name, ship_duration_days, revenue, cost, profit_margin,
 discounted_flag, revenue_band)
SET
    order_date = STR_TO_DATE(@order_date, '%Y-%m-%d'),
    ship_date  = STR_TO_DATE(@ship_date,  '%Y-%m-%d');

-- Verify
SELECT COUNT(*) FROM sales;

SELECT * FROM sales LIMIT 5;

-- Query 1 — Total Revenue, Profit and Margin by Year:
-- Margin is calculated as total profit / total revenue (revenue-weighted),
-- not as an average of row-level margins.
SELECT
    order_year,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales
GROUP BY order_year
ORDER BY order_year;

-- Query 2 — Revenue and Profit by Category and Sub-Category:
SELECT
    category,
    sub_category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct,
    SUM(quantity) AS total_units_sold
FROM sales
GROUP BY category, sub_category
ORDER BY total_revenue DESC;

-- Query 3 — Revenue by Region and Segment:
SELECT
    region,
    segment,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM sales
GROUP BY region, segment
ORDER BY total_revenue DESC;

-- Query 4 — Top 10 Products by Revenue:
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(revenue), 2)   AS total_revenue,
    ROUND(SUM(profit), 2)    AS total_profit,
    SUM(quantity)            AS units_sold
FROM sales
GROUP BY product_name, category, sub_category
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 5 — Monthly Revenue Trend:
SELECT
    order_year,
    order_month,
    order_month_name,
    ROUND(SUM(revenue), 2) AS monthly_revenue,
    ROUND(SUM(profit), 2) AS monthly_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM sales
GROUP BY order_year, order_month, order_month_name
ORDER BY order_year, order_month;

SELECT
    category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM sales
GROUP BY category
ORDER BY profit_margin_pct;
