# RetailPulse: Sales & Revenue Analytics with What-If Scenario Simulator

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)

## Overview

RetailPulse is an end-to-end business intelligence project that transforms raw retail transaction data into actionable insights through an interactive 5-page Power BI dashboard. The project features a **What-If Scenario Simulator** that enables business users to model pricing, discount, and volume changes in real time — projecting revenue and margin impact across product categories.

---

## Dashboard Pages

| Page | Description |
|---|---|
| 1 — Executive Summary | KPI cards (Revenue, Profit, Margin, Orders) + Monthly Revenue Trend (2014–2017) |
| 2 — Product Analysis | Top 10 Products by Revenue + Revenue by Category (Donut) |
| 3 — Profitability Analysis | Profit by Sub-Category + Revenue vs Profit Scatter (bubble chart) |
| 4 — Customer & Regional | Revenue by Region & Segment with interactive Year/Category/Ship Mode slicers |
| 5 — What-If Simulator | Real-time pricing, discount, and volume scenario modeling with DAX parameters |

---

## Key Business Insights

- **Technology** is the highest revenue category at 36.4% of total sales ($2.30M)
- **Tables** sub-category generates a **$17K net loss** despite $200K+ in revenue — highest loss-making segment
- **Copiers** deliver the highest profit ($56K) with strong margin efficiency
- **West and East Consumer** segments consistently outperform the $200K regional revenue target
- **November 2017** recorded peak monthly revenue of $118.45K — driven by Q4 holiday demand
- **South region** is the weakest performer across all customer segments

---

## Tech Stack

| Layer | Tools |
|---|---|
| Data Cleaning & EDA | Python (Pandas, NumPy), Jupyter Notebook |
| Database | MySQL, MySQL Workbench |
| Visualization & BI | Power BI Desktop, DAX |
| Version Control | Git, GitHub |

---

## Project Structure

```
RetailPulse/
│
├── data/
│   ├── Sample_-_Superstore.csv          # Raw dataset (Kaggle Superstore)
│   └── superstore_cleaned.csv           # Cleaned & feature-engineered dataset
│
├── scripts/
│   ├── retailpulse_cleaning.py          # Python data cleaning script
│   └── retailpulse_queries.sql          # 5 analytical MySQL queries
│
├── dashboard/
│   └── RetailPulse_Dashboard.pbix       # Power BI dashboard file
│
└── README.md
```

---

## Data Pipeline

```
Raw CSV (9,994 rows)
      ↓
Python Cleaning (Pandas)
  - Date parsing & formatting
  - Feature engineering (profit margin, cost, revenue bands)
  - 21 → 31 columns
      ↓
MySQL Database (retailpulse)
  - sales table with 31 columns
  - 5 analytical queries
      ↓
Power BI Dashboard
  - Direct MySQL connection
  - DAX measures
  - What-If parameters
```

---

## DAX Measures

```dax
Total Revenue = SUM('retailpulse sales'[revenue])
Total Profit = SUM('retailpulse sales'[profit])
Profit Margin % = DIVIDE(SUM('retailpulse sales'[profit]), SUM('retailpulse sales'[revenue]))
Total Orders = DISTINCTCOUNT('retailpulse sales'[order_id])
Avg Order Value = DIVIDE([Total Revenue], [Total Orders])
Projected Revenue = [Base Revenue] * (1 + 'Price Change'[Price Change Value]) * (1 + 'Volume Change'[Volume Change Value])
Projected Profit = [Projected Revenue] - SUM('retailpulse sales'[cost]) * (1 - 'Discount Adjustment'[Discount Adjustment Value])
Revenue Delta = [Projected Revenue] - [Base Revenue]
Margin Delta = [Projected Margin %] - [Profit Margin %]
```

---

## Dataset

**Source:** [Kaggle — Superstore Sales Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

- 9,994 rows × 21 original columns
- Date range: January 2014 — December 2017
- Covers: Orders, Customers, Products, Sales, Profit across US regions

---

## How to Run

**1. Clone the repository**
```bash
git clone https://github.com/jaira26/RetailPulse.git
```

**2. Run the Python cleaning script**
```bash
cd scripts
jupyter notebook retailpulse_cleaning.py
```

**3. Set up MySQL database**
```sql
CREATE DATABASE retailpulse;
-- Run retailpulse_queries.sql in MySQL Workbench
```

**4. Open Power BI Dashboard**
- Open `RetailPulse_Dashboard.pbix` in Power BI Desktop
- Update MySQL connection to your local credentials
- Refresh data

---

## Author

**Jairaghavendra Sridhar**
MS Data Analytics Engineering — Northeastern University
[LinkedIn](https://linkedin.com/in/jairaghavendrasridhar26) | [GitHub](https://github.com/jaira26)
