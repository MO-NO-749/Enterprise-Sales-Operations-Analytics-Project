# Data Catalog — Enterprise Sales & Operations Analytics

**Tool:** SQL Server (Bronze + Silver) → Power BI (Gold)  
**Source:** Single CSV — denormalized transaction data  
**Architecture:** Medallion (Bronze → Silver → Gold)

---

## Bronze Layer — dbo.Transactions

> Raw flat table. One row per transaction line item. All dimensions denormalized into a single table.

| Column | Data Type | Nullable | Description |
|---|---|---|---|
| TransactionID | INT | No | Unique transaction identifier |
| OrderNumber | INT | No | Order identifier (multiple line items per order) |
| LineItem | TINYINT | No | Line item number within an order |
| OrderDate | DATE | No | Date the order was placed |
| DeliveryDate | DATE | Yes | Date the order was delivered (null = not yet delivered) |
| Quantity | TINYINT | No | Number of units ordered |
| CustomerID | INT | No | Customer identifier |
| CustomerGender | NVARCHAR(50) | No | Customer gender |
| CustomerName | NVARCHAR(50) | No | Customer full name |
| CustomerCity | NVARCHAR(50) | No | Customer city |
| CustomerStateCode | NVARCHAR(50) | No | Customer state code |
| CustomerState | NVARCHAR(50) | No | Customer state name |
| CustomerZip | NVARCHAR(50) | No | Customer zip/postal code |
| CustomerCountry | NVARCHAR(50) | No | Customer country |
| CustomerContinent | NVARCHAR(50) | No | Customer continent |
| CustomerDOB | DATE | No | Customer date of birth |
| StoreID | TINYINT | No | Store identifier |
| StoreCountry | NVARCHAR(50) | No | Store country |
| StoreState | NVARCHAR(50) | No | Store state |
| StoreSqMeters | SMALLINT | No | Store size in square meters |
| StoreOpenDate | DATE | No | Date the store opened |
| ProductID | SMALLINT | No | Product identifier |
| ProductName | NVARCHAR(100) | No | Product name |
| ProductBrand | NVARCHAR(50) | No | Product brand |
| ProductColor | NVARCHAR(50) | No | Product color |
| ProductCost | MONEY | No | Cost per unit |
| ProductPrice | MONEY | No | Selling price per unit |
| ProductSubcategoryID | NVARCHAR (cleaned) | No | Subcategory ID (raw format required cleaning) |
| ProductSubcategory | NVARCHAR(50) | No | Product subcategory name |
| ProductCategoryID | TINYINT | No | Category ID |
| ProductCategory | NVARCHAR(50) | No | Product category name |

---

## Silver Layer — SQL Views

> Normalized into 8 views using SELECT DISTINCT. No new tables created — views query Bronze directly.

### View: Orders
Purpose: Store order header details for tracking.
columns:

| Column | Type | Description |
|---|---|---|
| OrderNumber | INT | Unique order identifier |
| OrderDate | DATE | Order placement date |
| DeliveryDate | DATE | Delivery date (nullable) |
| Delivary_Status | TEXT (derived) | 'Delivered' or 'NOT Delivered' — derived from DeliveryDate null check |
| CustomerID | INT | FK to Customers |
| StoreID | INT | FK to Stores |

### View: Order_Line_Items
Purpose: Record item level details for each order.
columns:

| Column | Type | Description |
|---|---|---|
| TransactionID | INT | Unique line item identifier |
| OrderNumber | INT | FK to Orders |
| LineItem | TINYINT | Line item sequence number |
| Quantity | TINYINT | Units ordered |
| ProductID | INT | FK to Products |

### View: Customers
Purpose: Maintain customer master data for analysis.
columns:

| Column | Type | Description |
|---|---|---|
| CustomerID | INT | Unique customer identifier |
| CustomerGender | NVARCHAR | Gender |
| CustomerName | NVARCHAR | Full name |
| CustomerCity | NVARCHAR | City |
| CustomerStateCode | NVARCHAR | State code |
| CustomerState | NVARCHAR | State name |
| CustomerZip | NVARCHAR | Zip code |
| CustomerCountry | NVARCHAR | Country |
| CustomerContinent | NVARCHAR | Continent |
| CustomerDOB | DATE | Date of birth |

### View: Products
Purpose: Maintain product master data with attributes.
columns:

| Column | Type | Description |
|---|---|---|
| ProductID | INT | Unique product identifier |
| ProductName | NVARCHAR | Product name |
| ProductBrand | NVARCHAR | Brand |
| ProductColor | NVARCHAR | Color |
| ProductCost | MONEY | Unit cost |
| ProductPrice | MONEY | Selling price |
| ProductSubcategoryID | NVARCHAR | Cleaned subcategory ID (REPLACE + LEFT applied) |

### View: Stores
Purpose: Maintain store master data with size and location. 
columns:

| Column | Type | Description |
|---|---|---|
| StoreID | INT | Unique store identifier |
| StoreCountry | NVARCHAR | Country |
| StoreState | NVARCHAR | State |
| StoreSqMeters | SMALLINT | Floor area in sq meters |
| StoreOpenDate | DATE | Opening date |

### View: Store_Product_Relation
Purpose: Maps products to stores, enabling analysis of product availability and performance across different store types and geographies.
columns:

| Column | Type | Description |
|---|---|---|
| StoreID | INT | FK to Stores |
| ProductID | INT | FK to Products |

### View: product_subcatagory
Purpose: Define product subcategory hierarchy.
columns:

| Column | Type | Description |
|---|---|---|
| ProductSubcategoryID | NVARCHAR | Cleaned subcategory ID |
| ProductSubcategory | NVARCHAR | Subcategory name |
| ProductCategoryID | TINYINT | FK to Product_Category |

### View: Product_Category
Purpose: Define product category hierarchy.
columns:

| Column | Type | Description |
|---|---|---|
| ProductCategoryID | TINYINT | Unique category identifier |
| ProductCategory | NVARCHAR | Category name |

---

## Gold Layer — Power BI Tables

### FACT_Order_Line_Items
| Column / Measure | Type | Description |
|---|---|---|
| TransactionID | INT | Row identifier |
| OrderNumber | INT | FK to DIM_Orders |
| LineItem | INT | Line item number |
| Quantity | INT | Units sold |
| ProductID | INT | FK to DIM_Products |
| CustomerID | TEXT (derived) | RELATED from DIM_Customers |
| Product price | CURRENCY (derived) | RELATED from DIM_Products[ProductPrice] |
| ProductCost | CURRENCY (derived) | RELATED from DIM_Products[ProductCost] |
| Revenue | CURRENCY (derived) | Quantity × Product price |
| COGS | CURRENCY (derived) | Quantity × ProductCost |
| Profit | CURRENCY (derived) | Revenue − COGS |

### DIM_Orders
| Column | Type | Description |
|---|---|---|
| OrderNumber | INT | Unique order identifier |
| OrderDate | DATE | Order date |
| DeliveryDate | DATE | Delivery date |
| Delivary_Status | TEXT | Delivered / NOT Delivered |
| Delivery_Time | INT (derived) | DATEDIFF(OrderDate, DeliveryDate, DAY) — blank if not delivered |
| CustomerID | INT | FK to DIM_Customers |
| StoreID | INT | FK to DIM_Stores |

### DIM_Customers
| Column | Type | Description |
|---|---|---|
| CustomerID | TEXT | Unique customer identifier |
| CustomerName | TEXT | Customer name |
| CustomerGender | TEXT | Gender |
| CustomerCity | TEXT | City |
| CustomerDOB | DATE | Date of birth |
| AGE | INT (derived) | DATEDIFF(CustomerDOB, MAX(DeliveryDate), YEAR) |
| Age_Group | TEXT (derived) | SWITCH: Below 18 / 19–30 / 31–45 / 46–60 / Above 60 |

### DIM_Products
| Column | Type | Description |
|---|---|---|
| ProductID | INT | Unique product identifier |
| ProductName | TEXT | Product name |
| ProductBrand | TEXT | Brand |
| ProductColor | TEXT | Color |
| ProductCost | CURRENCY | Unit cost |
| ProductPrice | CURRENCY | Selling price |
| ProductSubcategoryID | TEXT | FK to DIM_product_subcatagory |

### DIM_Stores
| Column | Type | Description |
|---|---|---|
| StoreID | INT | Unique store identifier |
| StoreCountry | TEXT | Country |
| StoreState | TEXT | State |
| StoreSqMeters | INT | Floor area |
| StoreOpenDate | DATE | Opening date |
| Store Type | TEXT (derived) | SWITCH: Hyper-Mart (≥2000) / Mega-Mart (1000–1999) / Super-Mart (500–999) / Small-Mart (<500) / Online (=0) |

### DIM_Product_Category
| Column | Type | Description |
|---|---|---|
| ProductCategoryID | INT | Unique category ID |
| ProductCategory | TEXT | Category name |

### DIM_product_subcatagory
| Column | Type | Description |
|---|---|---|
| ProductSubcategoryID | TEXT | Unique subcategory ID |
| ProductSubcategory | TEXT | Subcategory name |
| ProductCategoryID | INT | FK to DIM_Product_Category |

### Geo (Geographic dimension)
Purpose: Provide geographic hierarchy for regional insights.
columns:

| Column | Type | Description |
|---|---|---|
| CustomerCity | TEXT | City |
| CustomerContinent | TEXT | Continent |
| CustomerCountry | TEXT | Country |
| CustomerState | TEXT | State |
| CustomerStateCode | TEXT | State code |
| CustomerZip | TEXT | Zip code |

### Customer Order Distribution (calculated table)
Customer_Order_Distribution
Purpose: Tracks customer lifecycle, retention, and purchase frequency to support cohort analysis and customer segmentation.
columns:

| Column | Type | Description |
|---|---|---|
| CustomerID | INT | Customer identifier |
| First_Purchease_Date | DATE | Date of first order |
| OrdersCount | INT | Total number of orders per customer |

### Calender (Date dimension)
| Column | Type | Description |
|---|---|---|
| Date | DATE | Full date |
| Day_No | TEXT | Day number (formatted "dd") |
| Day_Name | TEXT | Day name (e.g. Monday) |
| Month | TEXT | Month number (formatted "mm") |
| Month_Name | TEXT | Month name (e.g. January) |
| Quater_No | TEXT | Quarter (e.g. Q1) |
| Reporting_Period | TEXT | mmm-yy format (e.g. Jan-21) |
| Year | TEXT | Year (formatted "yyyy") |
| Weekday | INT | Day of week number (Mon=1) |
| Weeknum | INT | Week number |
| Start of month | DATE | First day of month |
| Start of quater | DATE | First day of quarter |
| End of Month | DATE | Last day of month |
| Date Hierarchy 2 | Hierarchy | Year → Month → Date |

---

## Parameter / Slicer Tables

| Table | Purpose |
|---|---|
| ParameterMAIN | Toggles main KPI: Revenue / COGS / Profit / Units |
| Parameter_Geo | Toggles geo level: Continent / Country / State / City |
| Parameter_product | Toggles product level: Category / Subcategory |
| AVG_Parameter | Toggles average metric: AVG_Revenue / AVG_COGS / AVG_Profit / AVG_Unit |
| Customer_Parameter | Toggles customer metric: New / Returning Customers |
| Parameter_product_scraterplot | Scatter X-axis: Product Cost / Product Price |
| Parameter_CUS_NUMBER | Top-N customer slicer (0–5000) |
| Number_TopButtom | Top/Bottom N slicer (1–20) |
| Table_TopButtom_Sclicer | Top / Bottom toggle |
| MovingAVG-DAYS | Moving average window (1–365 days) |

## Final Architecture Flow

ERP / Transactional System (dbo.Transactions)
↓
SQL Staging Layer + Data Warehouse (Normalized Views: Orders, Order_Line_Items, Customers, Products,  Stores, : Product_Subcategory, Product_Category, Store_Product_Relation)
↓
ETL in MSSQL Server to power quary (FACT_Order_Line_Items, DIM_Orders, DIM_Customers, DIM_Products, DIM_Stores, DIM_Geo)
↓
Power BI Semantic Model (DAX Measures, Parameters, DIM_Calendar, Bridge Tables: Store_Product_Relation, Customer_Order_Distribution)
↓
Dashboards & KPI Reports (Sales Overview, Product Analysis, Customer Insights, Store Performance, Order Metrics)
