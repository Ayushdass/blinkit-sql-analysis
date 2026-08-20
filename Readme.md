**# Blinkit Grocery Sales Analysis**

SQL-based analysis of Blinkit's grocery sales data — exploring total revenue, product category performance, outlet-level KPIs, and customer preferences using MySQL.


**# Objective**

To analyse grocery sales data like a real data analyst would: build core business KPIs, identify top-performing product categories and outlets, and generate insights that could inform business decisions around pricing, stocking, and outlet strategy.


**# Tools Used**

\- \*\*MySQL Workbench\*\* (SQL queries, data cleaning, KPI calculation)

\- \*\*Dataset:\*\* BlinkIT Grocery Data (\[Kaggle](https://www.kaggle.com/datasets/mukeshgadri/blinkit-dataset))


**# Dataset Overview**

The dataset contains item-level and outlet-level sales records with the following key columns:


| Column | Description |

|---|---|

| `Item\_Identifier` | Unique product ID |

| `Item\_Weight` | Weight of the item |

| `Item\_Fat\_Content` | Low Fat / Regular |

| `Item\_Visibility` | % of total display area allocated to the item |

| `Item\_Type` | Product category (e.g. Dairy, Snacks, Household) |

| `Item\_MRP` | Maximum Retail Price |

| `Outlet\_Identifier` | Unique outlet ID |

| `Outlet\_Establishment\_Year` | Year the outlet was set up |

| `Outlet\_Size` | Small / Medium / Large |

| `Outlet\_Location\_Type` | Tier 1 / Tier 2 / Tier 3 city |

| `Outlet\_Type` | Grocery Store / Supermarket Type 1/2/3 |

| `Item\_Outlet\_Sales` | Sales revenue generated (target variable) |



**# Process**

1\. \*\*Data Cleaning\*\* — checked for null values, standardised inconsistent `Item\_Fat\_Content` labels (`LF`, `low fat` → `Low Fat`; `reg` → `Regular`)

2\. \*\*KPI Calculation\*\* — total revenue, average sales per item, total items sold, average MRP

3\. \*\*Business Analysis\*\* — sales breakdown by fat content, item type, outlet size, location tier, outlet type, and MRP price range

4\. \*\*Window Functions\*\* — ranked item categories by revenue, compared outlet performance against the overall average, and calculated running (cumulative) revenue totals


All queries are in \[`blinkit\_analysis.sql`](./blinkit\_analysis.sql).



**# Key Findings**

See \[`findings.md`](./findings.md) for the full write-up.


**# Skills Demonstrated**

SQL fundamentals · Data cleaning · Aggregations (`GROUP BY`, `HAVING`) · KPI design · Window functions (`RANK()`, `OVER()`) · Business/retail analytics thinking



