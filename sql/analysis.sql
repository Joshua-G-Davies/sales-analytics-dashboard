-- Sales Analytics Project
-- This script includes:
-- 1. Data cleaning steps
-- 2. Customer segmentation logic

-- =========================
-- DATA CLEANING
-- =========================

-- Create clean_sales view
DROP VIEW IF EXISTS clean_sales;

CREATE VIEW clean_sales AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    UnitPrice,
    Quantity * UnitPrice AS Revenue,
    CustomerID,
    Country,
    InvoiceDate
FROM online_retail
WHERE
    InvoiceNo NOT LIKE 'C%'
    AND Quantity > 0
    AND UnitPrice > 0;

-- =========================
-- CUSTOMER SEGMENTATION
-- =========================

-- Customer segmentation (low / medium / high spend)
WITH customer_spend AS (
    SELECT
        CustomerID,
        SUM(Revenue) AS total_spend
    FROM clean_sales
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID
)
SELECT
    CASE
        WHEN total_spend >= 1000 THEN 'High'
        WHEN total_spend >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_spend), 2) AS segment_revenue
FROM customer_spend
GROUP BY customer_segment;
