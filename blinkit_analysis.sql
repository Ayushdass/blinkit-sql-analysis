-- ============================================================
-- BLINKIT GROCERY SALES ANALYSIS
-- Tool: MySQL Workbench
-- Dataset: BlinkIT Grocery Data (Kaggle)
-- Author: Ayush Das
-- ============================================================

-- ------------------------------------------------------------
-- SETUP
-- ------------------------------------------------------------

CREATE DATABASE blinkit_analysis;
USE blinkit_analysis;

CREATE TABLE blinkit (
Item_Identifier            TEXT,
    Item_Weight                DOUBLE,
    Item_Fat_Content           TEXT,
    Item_Visibility            DOUBLE,
    Item_Type                  TEXT,
    Item_MRP                   DOUBLE,
    Outlet_Identifier          TEXT,
    Outlet_Establishment_Year  INT,
    Outlet_Size                TEXT,
    Outlet_Location_Type       TEXT,
    Outlet_Type                TEXT,
    Item_Outlet_Sales          DOUBLE
);

-- Data imported via MySQL Workbench Table Data Import Wizard
-- (BlinkIT Grocery Data.csv)

SET SQL_SAFE_UPDATES = 0;

-- ------------------------------------------------------------
-- STEP 1: DATA CLEANING
-- ------------------------------------------------------------

-- Check row count
SELECT COUNT(*) FROM blinkit;

-- Check for nulls in key columns
SELECT
  SUM(CASE WHEN Item_Identifier IS NULL THEN 1 ELSE 0 END) AS null_item_id,
  SUM(CASE WHEN Item_Outlet_Sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN Outlet_Type IS NULL THEN 1 ELSE 0 END) AS null_outlet_type
FROM blinkit;

-- Check inconsistent Fat Content labels
SELECT DISTINCT Item_Fat_Content FROM blinkit;

-- Standardise Fat Content labels
UPDATE blinkit SET Item_Fat_Content = 'Low Fat'
WHERE Item_Fat_Content IN ('LF', 'low fat');

UPDATE blinkit SET Item_Fat_Content = 'Regular'
WHERE Item_Fat_Content = 'reg';

-- Verify cleanup
SELECT DISTINCT Item_Fat_Content FROM blinkit;

-- ------------------------------------------------------------
-- STEP 2: KPIs
-- ------------------------------------------------------------

-- KPI 1: Total Sales Revenue
SELECT ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales FROM blinkit;

-- KPI 2: Average Sales per item
SELECT ROUND(AVG(Item_Outlet_Sales), 2) AS avg_sales FROM blinkit;

-- KPI 3: Total number of items sold
SELECT COUNT(*) AS total_items FROM blinkit;

-- KPI 4: Average Item MRP
SELECT ROUND(AVG(Item_MRP), 2) AS avg_mrp FROM blinkit;

-- ------------------------------------------------------------
-- STEP 3: BUSINESS ANALYSIS
-- ------------------------------------------------------------

-- Q1: Sales by Fat Content — do customers prefer Low Fat?
SELECT Item_Fat_Content,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       COUNT(*) AS item_count
FROM blinkit
GROUP BY Item_Fat_Content;

-- Q2: Which item types generate the most revenue?
SELECT Item_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       COUNT(*) AS item_count
FROM blinkit
GROUP BY Item_Type
ORDER BY total_sales DESC;

-- Q3: Sales performance by outlet size
SELECT Outlet_Size,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       COUNT(*) AS outlet_count,
       ROUND(AVG(Item_Outlet_Sales), 2) AS avg_sales_per_item
FROM blinkit
GROUP BY Outlet_Size
ORDER BY total_sales DESC;

-- Q4: Which location tier performs best?
SELECT Outlet_Location_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;

-- Q5: Sales by outlet type
SELECT Outlet_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       COUNT(*) AS item_count,
       ROUND(AVG(Item_Outlet_Sales), 2) AS avg_sales
FROM blinkit
GROUP BY Outlet_Type
ORDER BY total_sales DESC;

-- Q6: Sales distribution by MRP price range
SELECT
  CASE
    WHEN Item_MRP < 50 THEN 'Budget (Under 50)'
    WHEN Item_MRP BETWEEN 50 AND 100 THEN 'Mid (50-100)'
    WHEN Item_MRP BETWEEN 100 AND 200 THEN 'Premium (100-200)'
    ELSE 'Luxury (200+)'
  END AS price_range,
  COUNT(*) AS item_count,
  ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit
GROUP BY price_range
ORDER BY total_sales DESC;

-- Q7: Best performing outlet type + location combo
SELECT Outlet_Type, Outlet_Location_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales
FROM blinkit
GROUP BY Outlet_Type, Outlet_Location_Type
ORDER BY total_sales DESC
LIMIT 10;

-- Q8: Sales trend by outlet establishment year
SELECT Outlet_Establishment_Year,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       COUNT(*) AS item_count
FROM blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

-- ------------------------------------------------------------
-- STEP 4: WINDOW FUNCTIONS (MySQL 8.0+)
-- ------------------------------------------------------------

-- Rank each Item_Type by total sales
SELECT Item_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       RANK() OVER (ORDER BY SUM(Item_Outlet_Sales) DESC) AS sales_rank
FROM blinkit
GROUP BY Item_Type;

-- Each outlet type's sales vs overall average
SELECT Outlet_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS outlet_sales,
       ROUND(AVG(SUM(Item_Outlet_Sales)) OVER (), 2) AS avg_across_outlets,
       ROUND(SUM(Item_Outlet_Sales) - AVG(SUM(Item_Outlet_Sales)) OVER (), 2) AS diff_from_avg
FROM blinkit
GROUP BY Outlet_Type;

-- Cumulative revenue by category (running total, ranked)
SELECT Item_Type,
       ROUND(SUM(Item_Outlet_Sales), 2) AS total_sales,
       ROUND(SUM(SUM(Item_Outlet_Sales)) OVER (ORDER BY SUM(Item_Outlet_Sales) DESC), 2) AS running_total
FROM blinkit
GROUP BY Item_Type
ORDER BY total_sales DESC;