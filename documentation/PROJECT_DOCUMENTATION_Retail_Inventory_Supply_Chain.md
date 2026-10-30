# Project Documentation
## Retail Inventory & Supply Chain Intelligence Dashboard

**Artifact:** `Retail_Inventory_Supply_Chain_Dashboard.pbix`  
**Platform:** Microsoft Power BI  
**Report canvas:** 1920 × 1080 (16:9)  
**Report pages found in the supplied PBIX:** 1

---

## 1. Executive Summary

The Retail Inventory & Supply Chain Intelligence Dashboard consolidates sales, product, store, inventory, purchase-order, and supplier indicators into a single Power BI report. Its purpose is to give a retail operations or supply-chain user a concise view of commercial activity and operational performance.

The report combines five KPI cards, seven analytical visuals, and three report filters. It supports exploration of sales trends, store comparisons, product demand, stock levels, purchase-order status, and supplier delivery performance.

This document describes the report structure that is present in the supplied PBIX. It does not invent numerical findings or business conclusions because no exported dashboard data, source dataset, or screenshots with readable values were supplied.

## 2. Project Objectives

The dashboard is designed to support the following objectives:

- Monitor sales revenue and units sold.
- Compare sales performance across stores.
- Track sales revenue over time.
- Identify products with high unit sales.
- Monitor closing inventory and products flagged as low stock.
- Review purchase-order status and late purchase orders.
- Compare supplier delivery timeliness and lead-time variance.
- Allow users to filter the report by store region, order date, and purchase-order status.

## 3. Data Model Overview

The PBIX model contains the following tables:

| Table | Apparent business role in the report |
|---|---|
| `orders` | Order-level information, including the order date used in the trend visual |
| `order_items` | Sales/revenue and units-sold measures |
| `products` | Product names and low-stock product measure |
| `stores` | Store names and store region |
| `purchase_orders` | Purchase-order status, late purchase orders, delivery rate, and lead-time variance |
| `suppliers` | Supplier names used for supplier comparisons |
| `inventory_snapshots` | Closing-stock measure used for inventory-by-store analysis |

The descriptions above are inferred from the fields and measures referenced by the report visuals. Confirm them against the actual source schema and relationships before treating this table as a formal data dictionary.

### Data grain and relationships

The PBIX includes separate tables for orders, order items, products, stores, purchase orders, suppliers, and inventory snapshots. The exact grain of each table, primary keys, foreign keys, relationship cardinality, filter direction, and handling of duplicate records should be documented after reviewing Model view in Power BI.

Recommended checks:

1. Identify the primary key of each table.
2. Confirm the relationship between `orders` and `order_items`.
3. Confirm how products and stores relate to order items.
4. Confirm how purchase orders relate to suppliers.
5. Confirm how inventory snapshots relate to stores and products.
6. Check for duplicate keys, orphan records, blank dates, and missing supplier/store/product references.
7. Confirm whether inventory snapshots represent daily, weekly, monthly, or point-in-time balances.

## 4. Dashboard Layout and Components

The supplied PBIX contains one 1920 × 1080 report page. The report page title is **Retail Inventory & Supply Chain Intelligence Dashboard**.

### 4.1 KPI cards

| KPI | Report measure | Intended interpretation |
|---|---|---|
| Total Sales Revenue | `Total Sales Revenue` | Total revenue represented by the sales model |
| Total Units Sold | `Total Units Sold` | Total quantity of units sold |
| Low Stock Products | `Low Stock Products` | Number of products identified as low stock |
| Late Purchase Orders | `Late Purchase Orders` | Number of purchase orders classified as late |
| Supplier On-Time Delivery Rate | `Supplier On-Time Delivery Rate` | Share/rate of supplier deliveries classified as on time |

**Validation required:** The report metadata exposes these measure names but not their complete DAX formulas. Before publishing formal KPI definitions, inspect each measure in Power BI and record its formula, aggregation logic, unit, filters, and business rule. In particular, confirm the low-stock threshold and the denominator used for the on-time delivery rate.

### 4.2 Sales Revenue by Store

- Visual type: clustered bar chart.
- Category: `stores[store_name]`.
- Value: `Total Sales Revenue`.
- Purpose: compare revenue contribution across stores.

Potential business use: identify stores contributing more or less revenue and investigate differences alongside store region, product mix, and sales trends.

### 4.3 Sales Trend Over Time

- Visual type: line chart.
- Time field: `orders[order_date]`.
- Value: `Total Sales Revenue`.
- Purpose: examine how revenue changes over time.

Potential business use: identify growth or decline periods, seasonality, and unusual changes. Confirm date coverage and whether the chart uses daily, monthly, or another date granularity.

### 4.4 Top Products by Units Sold

- Visual type: clustered bar chart.
- Category: `products[product_name]`.
- Value: `Total Units Sold`.
- Purpose: identify products with the highest unit volume.

Potential business use: support demand review, assortment decisions, and replenishment discussions. High unit volume alone does not establish profitability or future demand.

### 4.5 Purchase Order Status

- Visual type: donut chart.
- Category: `purchase_orders[po_status]`.
- Value: count of `purchase_order_id`.
- Purpose: show the distribution of purchase orders by status.

Potential business use: understand the current or recorded mix of purchase-order statuses. Confirm whether the status values represent current state or historical status at a particular snapshot.

### 4.6 Inventory by Store

- Visual type: clustered column chart.
- Category: `stores[store_name]`.
- Value: `Total Closing Stock`.
- Purpose: compare closing stock across stores.

Potential business use: identify differences in recorded inventory between stores. Interpret totals carefully if snapshots are taken at different dates or if stock is counted at different levels of detail.

### 4.7 Late Purchase Orders by Supplier

- Visual type: clustered bar chart.
- Category: `suppliers[supplier_name]`.
- Value: `Late Purchase Orders`.
- Purpose: compare late purchase-order counts by supplier.

Potential business use: identify suppliers for further delivery-performance investigation. A raw count should be interpreted alongside each supplier's total purchase-order volume.

### 4.8 Average Lead-Time Variance by Supplier

- Visual type: clustered bar chart.
- Category: `suppliers[supplier_name]`.
- Value: `Average Lead-Time Variance`.
- Purpose: compare average lead-time variance across suppliers.

Potential business use: identify suppliers whose delivery timing differs from the expected lead time. Confirm the sign convention (positive/negative), unit (days or another unit), and whether the measure is averaged per order or another grain.

## 5. Report Filters

The report includes three slicers:

| Filter | Field | Intended use |
|---|---|---|
| Store Region | `stores[region]` | Focus the report on a selected store region |
| Order Date | `orders[order_date]` | Restrict sales analysis to a selected date or period |
| Purchase Order Status | `purchase_orders[po_status]` | Focus purchasing analysis on selected order statuses |

Validate the model relationships and slicer interactions to ensure that each filter affects only the visuals it is intended to affect.

## 6. Suggested Analytical Workflow

A user can explore the report in the following sequence:

1. Select a store region and an order-date range.
2. Review total sales revenue and total units sold.
3. Compare store-level revenue and the sales trend.
4. Identify high-volume products.
5. Review closing stock and the low-stock product KPI.
6. Select a purchase-order status.
7. Compare late purchase orders and lead-time variance across suppliers.
8. Investigate suppliers with high late-order counts relative to their total order volume.

This is a suggested workflow, not a claim that the report has been validated against a particular operational process.

## 7. KPI Definition and Validation Checklist

Before using the dashboard for business decisions or presenting numerical claims, document and validate:

| Measure | Questions to verify |
|---|---|
| Total Sales Revenue | Is revenue based on item price, line total, tax, freight, discounts, or another definition? What currency is used? |
| Total Units Sold | Does this sum item quantities? Are cancelled or returned items excluded? |
| Low Stock Products | What stock threshold is used? Is the measure evaluated at product, store-product, or global product level? |
| Late Purchase Orders | What planned and actual dates define a late order? Are open orders included? |
| Supplier On-Time Delivery Rate | What counts as on time? What is the denominator? Are incomplete or cancelled POs excluded? |
| Total Closing Stock | Is this a sum of the latest snapshot, or can multiple snapshot dates be included simultaneously? |
| Average Lead-Time Variance | How is variance calculated, what is its unit, and what does a positive value mean? |

Recommended validation steps:

- Reconcile revenue and unit totals to source records.
- Test KPI results for a small manually checked sample.
- Check date and status filters.
- Confirm whether returned, cancelled, or incomplete transactions are included.
- Confirm the inventory snapshot date used in totals.
- Compare supplier counts and rates using both absolute and percentage measures.
- Check how blanks and missing dates are handled.

## 8. Design and Usability

The report uses a 16:9 canvas with a light page background and a dark-blue title treatment. The KPI cards and charts are arranged on a single overview page.

Recommended improvements, if the report is extended:

- Add clear units and currency labels to KPI values.
- Display the date range or latest inventory snapshot date.
- Add tooltips with definitions and supporting counts.
- Show both late-order count and late-order rate by supplier.
- Consider a supplier scorecard with total POs, late POs, on-time rate, and average lead-time variance.
- Add drill-through to product, store, and supplier detail.
- Ensure chart titles explain the metric and comparison dimension.
- Use accessible contrast and consistent formatting.

## 9. Limitations and Assumptions

- The source data files and source-system description were not included with the supplied PBIX. Dataset provenance, licensing, date coverage, and refresh frequency therefore remain to be documented.
- The exact DAX formulas were not available in the report definition inspected for this document. KPI definitions in this document are intended interpretations, not verified formulas.
- The report contains one page in the supplied PBIX. No additional detail or drill-through pages are documented here.
- A high count of late purchase orders may reflect higher supplier volume; supplier comparisons should include rates or denominators.
- Inventory totals can be misleading if multiple snapshot dates are aggregated together.
- Descriptive dashboard patterns do not prove causation.

## 10. Recommended Future Enhancements

1. Add a documented data source and data dictionary.
2. Add inventory ageing and days-of-inventory measures.
3. Add reorder-point and stockout-risk indicators where the required inputs exist.
4. Add purchase-order cycle time and supplier on-time rate trends.
5. Add supplier performance scorecards with denominators.
6. Add store-product drill-through and inventory movement analysis.
7. Add data-quality checks and a refresh timestamp.
8. Add a written insights summary supported by validated dashboard values.
9. Capture screenshots of the final report page for the GitHub README.

## 11. Suggested GitHub Repository Structure

```text
retail-inventory-supply-chain-dashboard/
├── Retail_Inventory_Supply_Chain_Dashboard.pbix
├── README.md
├── PROJECT_DOCUMENTATION.md
└── screenshots/
    └── dashboard_overview.png
```

Only include source files that you are permitted to share. Avoid uploading confidential business data, credentials, or personally identifiable information.

## 12. Conclusion

The dashboard provides a consolidated view of retail sales, inventory, purchase-order status, and supplier delivery indicators. Its current structure supports exploratory analysis across stores, products, and suppliers. The next step toward a fully auditable portfolio project is to document the source data, confirm the DAX definitions and business rules, validate the relationships and totals, and add a short findings summary based on verified results.
