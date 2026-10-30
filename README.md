# Retail Inventory & Supply Chain Intelligence Dashboard

An interactive Power BI dashboard designed to monitor retail sales, product movement, inventory levels, purchase-order delays, and supplier delivery performance across stores.

## Project Overview

This project brings together key retail operations and supply-chain indicators in a single report. It is intended to help business users explore sales performance, identify products that may need inventory attention, and monitor purchasing and supplier delivery issues.

The report is built in Microsoft Power BI and uses a model organized around six tables:

- `orders`
- `order_items`
- `products`
- `stores`
- `purchase_orders`
- `suppliers`
- `inventory_snapshots`

> **Data note:** The PBIX report contains the data model and report definition, but the source dataset, source-system description, and data dictionary were not supplied with this project file. Add those details here once they are confirmed. Do not describe the data as live or production data unless that is accurate.

## Dashboard Contents

The current PBIX contains one report page titled **Retail Inventory & Supply Chain Intelligence Dashboard**.

### KPI cards

- **Total Sales Revenue** — sales revenue measure.
- **Total Units Sold** — unit-volume measure.
- **Low Stock Products** — count/measure of products flagged as low stock.
- **Late Purchase Orders** — count/measure of late purchase orders.
- **Supplier On-Time Delivery Rate** — supplier delivery timeliness measure.

### Visual analysis

- **Sales Revenue by Store** — compares sales revenue across stores.
- **Sales Trend Over Time** — tracks sales revenue by order date.
- **Top Products by Units Sold** — highlights products with the highest unit volume.
- **Purchase Order Status** — shows purchase orders by status.
- **Inventory by Store** — compares closing stock across stores.
- **Late Purchase Orders by Supplier** — identifies suppliers associated with late purchase orders.
- **Average Lead-Time Variance by Supplier** — compares supplier lead-time variance.

### Report filters

- Store Region
- Order Date
- Purchase Order Status

## Business Questions

The dashboard is structured to help investigate questions such as:

1. How is sales revenue changing over time?
2. Which stores contribute the most sales revenue?
3. Which products have the highest unit sales?
4. How much closing inventory is recorded by store?
5. How many products are flagged as low stock?
6. How are purchase orders distributed by status?
7. Which suppliers have the most late purchase orders?
8. How does supplier lead-time variance differ?
9. What is the overall supplier on-time delivery rate?

## Tools

- Microsoft Power BI Desktop
- Power Query / Power BI data model
- DAX measures (measure names are visible in the report; exact formulas should be documented from the model)

## Repository Structure

Suggested GitHub structure:

```text
retail-inventory-supply-chain-dashboard/
├── Retail_Inventory_Supply_Chain_Dashboard.pbix
├── README.md
├── PROJECT_DOCUMENTATION.md
└── screenshots/
    └── dashboard_overview.png
```

If you include source data or transformation files, place them in clearly named folders and remove confidential or personally identifiable information before publishing.

## How to Use

1. Download `Retail_Inventory_Supply_Chain_Dashboard.pbix`.
2. Open it using Microsoft Power BI Desktop.
3. Allow the report to load.
4. Use the Store Region, Order Date, and Purchase Order Status filters to explore the report.
5. Select chart elements to cross-filter other visuals where supported.

## Important Interpretation Notes

- A low-stock flag depends on the threshold and logic defined in the data model. Confirm that definition before using it for operational decisions.
- The exact calculation of sales revenue, supplier on-time delivery rate, and lead-time variance depends on the DAX definitions and underlying data. Review and document those formulas before treating them as formal business KPIs.
- The report file alone does not establish whether the data is historical, simulated, anonymized, or connected to a live source. State the true source and refresh frequency when known.
- Visual associations are useful for investigation but do not, by themselves, establish the cause of a delay or inventory issue.

## Future Enhancements

- Add a data dictionary and source-data documentation.
- Document KPI formulas, units, thresholds, and business rules.
- Add inventory ageing, stockout risk, reorder-point, and days-of-inventory measures where the required data is available.
- Add supplier scorecards and store-level drill-through pages.
- Add a refresh timestamp and data-quality checks.
- Include annotated screenshots and a concise findings summary.

## Author

**Nisarg Kamble**

Power BI portfolio project focused on retail analytics, inventory monitoring, and supply-chain performance.
