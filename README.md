# 📊 Enterprise Sales & Operations Analytics Project

Welcome to the **Enterprise Sales & Operations Analytics** repository! 🚀

**This project demonstrates a full-stack analytics project built on SQL Server using Medallion Architecture, delivering a 6-page Power BI report covering sales performance, product analysis, customer behaviour, purchase patterns, store efficiency, and order operations — across ₹55.76M in total revenue from 2016 to 2021.**

## 🗂️ Project Structure

```
├── SQL/
│   ├── Bronze/
│   │   ├── DDL_bronze_dbo.sql              # Creates raw Transactions table
│   │   └── load_data_BRONZE_Procedure.sql  # Stored procedure: BULK INSERT from CSV
│   ├── Silver/
│   │   └── Normalization_and_Cleaning.sql  # Creates 8 SQL Views (normalized tables)
│   └── Gold/
│       └── Power_Query_transformations.sql # Age calculation + derived columns for PBI
├── PowerBI/
│   └── EnterpriseAnalytics.pbix
└── Docs/
    ├── Data_Catalog.md
    ├── Data_Model.md
    └── Functional_Requirements.md
```

## 🏗️ Data Architecture
The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Layer](DOC/Data%20Layer.png)
1.. **Bronze Layer**: This layer Raw data .
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready semantic data modeled into a snowflake schema for reporting and analytics and proformance.

---

## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the Power BI of Visualization.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating *POWER BI* reports and dashboards for actionable insights.

---

## 🚀 Project Requirements

### Building the Dashboard

#### Objective
Develop a modern data warehouse using SQL Server to Normalize Transaction data, enabling analytical reporting and informed decision-making though Power Bi Visuals.

#### Specifications
- **Data Sources**: Import data from Reported file provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Normalization**: separeted into multiple sources{Tables} ,Snowflack data model designed for analytical queries and scalability.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

### Tools used
- **MSSQL SERVER**
- **draw.io**
- **Power BI**
- **Data Studio**
- **Notion**



### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop Power BI Dashboard for analytics to deliver detailed insights into:
- **Customer Behavior** 
- **Product Performance**
- **Sales Trends**
- **Purchase Behavior**
- **Delivery Performance**

## 🚀 Key Findings

1. **Peak revenue year was 2019** — declined sharply in 2020–2021
2. **Profit margin is 58.58%** — healthy, but COGS at 41.42% worth monitoring by category
3. **Hyper-Mart drives 33.28% of revenue** — largest store type by contribution
4. **84.41% of orders delivered on time** — 15.59% miss SLA, worth investigating by region
5. **Average 2.21 orders per customer** — low repeat purchase rate suggests retention opportunity
6. **Online channel accounts for 20.45% of revenue** — growing channel worth separate tracking

---

## 📁 How to Use

1. Clone the repository
2. Run `DDL_bronze_dbo.sql` to create the Transactions table
3. Update the file path in `load_data_BRONZE_Procedure.sql` and execute
4. Run `Normalization_and_Cleaning.sql` to create Silver views
5. Open `EnterpriseAnalytics.pbix` in Power BI Desktop
6. Refresh the data model

---
These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

For more details, refer to [Documentation](DOC/) & [Metadata](Dataset/Metadata)

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 🌟 About Me

Hi there! I'm **Monojit Samanta**. I’m an B.com graduate want to excel in my professional life with data in front and finance as domain.

Let's stay in touch! Feel free to connect with me on the following platform:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/monojit-samanta-720889383)

