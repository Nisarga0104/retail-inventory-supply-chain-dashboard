USE retail_analytics;

-- 1. Revenue and order summary (revenue excludes cancelled orders)
SELECT o.order_status,
       COUNT(DISTINCT o.order_id) AS order_count,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),2) AS item_revenue
FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
WHERE o.order_status IN ('Delivered','Processing','Returned')
GROUP BY o.order_status ORDER BY item_revenue DESC;

-- 2. Monthly delivered revenue
SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS order_month,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)),2) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
WHERE o.order_status='Delivered'
GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
ORDER BY order_month;

-- 3. Category revenue and estimated gross profit
SELECT p.category,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)),2) AS revenue,
       ROUND(SUM(oi.quantity*(oi.unit_price*(1-oi.discount_pct)-p.unit_cost)),2) AS gross_profit
FROM order_items oi JOIN orders o ON o.order_id=oi.order_id
JOIN products p ON p.product_id=oi.product_id
WHERE o.order_status='Delivered'
GROUP BY p.category ORDER BY gross_profit DESC;

-- 4. Top 10 customers by delivered spend
SELECT c.customer_id,c.customer_name,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)),2) AS customer_spend,
       COUNT(DISTINCT o.order_id) AS delivered_orders
FROM customers c JOIN orders o ON o.customer_id=c.customer_id
JOIN order_items oi ON oi.order_id=o.order_id
WHERE o.order_status='Delivered'
GROUP BY c.customer_id,c.customer_name
ORDER BY customer_spend DESC LIMIT 10;

-- 5. Order status mix
SELECT order_status,COUNT(*) AS orders,
       ROUND(100*COUNT(*)/(SELECT COUNT(*) FROM orders),2) AS pct_of_orders
FROM orders GROUP BY order_status ORDER BY orders DESC;

-- 6. Repeat-purchase customers
SELECT COUNT(*) AS customers_with_multiple_orders
FROM (
  SELECT customer_id FROM orders WHERE order_status='Delivered'
  GROUP BY customer_id HAVING COUNT(DISTINCT order_id)>1
) x;

-- 7. Supplier lead-time performance
SELECT s.supplier_name,COUNT(*) AS purchase_orders,
       ROUND(AVG(po.actual_lead_days),1) AS avg_actual_lead_days,
       ROUND(AVG(po.expected_lead_days),1) AS avg_expected_lead_days,
       SUM(po.po_status='Delayed') AS delayed_pos,
       ROUND(100*AVG(po.po_status='Delayed'),1) AS delay_rate_pct
FROM suppliers s JOIN purchase_orders po ON po.supplier_id=s.supplier_id
GROUP BY s.supplier_id,s.supplier_name
ORDER BY delay_rate_pct DESC;

-- 8. Latest inventory snapshot and low-stock flag
WITH latest_snapshot AS (
  SELECT MAX(snapshot_date) AS max_date FROM inventory_snapshots
)
SELECT st.store_name,p.product_name,p.category,i.closing_units,p.reorder_level,
       CASE WHEN i.closing_units < p.reorder_level THEN 'REORDER' ELSE 'OK' END AS stock_status
FROM inventory_snapshots i
JOIN latest_snapshot ls ON i.snapshot_date=ls.max_date
JOIN products p ON p.product_id=i.product_id
JOIN stores st ON st.store_id=i.store_id
WHERE i.closing_units < p.reorder_level
ORDER BY (p.reorder_level-i.closing_units) DESC;

-- 9. Rank products by delivered revenue using a window function
WITH product_sales AS (
  SELECT p.product_id,p.product_name,
         SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)) AS revenue
  FROM products p JOIN order_items oi ON oi.product_id=p.product_id
  JOIN orders o ON o.order_id=oi.order_id
  WHERE o.order_status='Delivered'
  GROUP BY p.product_id,p.product_name
)
SELECT product_id,product_name,ROUND(revenue,2) AS revenue,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_sales ORDER BY revenue_rank LIMIT 20;

-- 10. Monthly revenue with previous month and percentage change
WITH monthly AS (
  SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS order_month,
         SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)) AS revenue
  FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
  WHERE o.order_status='Delivered'
  GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
),
lagged AS (
  SELECT order_month,revenue,LAG(revenue) OVER (ORDER BY order_month) AS prev_month_revenue
  FROM monthly
)
SELECT order_month,ROUND(revenue,2) AS revenue,
       ROUND(prev_month_revenue,2) AS prev_month_revenue,
       ROUND(100*(revenue-prev_month_revenue)/NULLIF(prev_month_revenue,0),2) AS mom_growth_pct
FROM lagged ORDER BY order_month;

-- 11. Create a reusable view for delivered sales
CREATE OR REPLACE VIEW vw_delivered_sales AS
SELECT o.order_id,o.order_date,o.customer_id,o.store_id,p.product_id,p.product_name,p.category,
       oi.quantity,oi.unit_price,oi.discount_pct,
       oi.quantity*oi.unit_price*(1-oi.discount_pct) AS net_sales,
       oi.quantity*(oi.unit_price*(1-oi.discount_pct)-p.unit_cost) AS estimated_gross_profit
FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
JOIN products p ON p.product_id=oi.product_id
WHERE o.order_status='Delivered';

-- Example: SELECT category, SUM(net_sales) revenue FROM vw_delivered_sales GROUP BY category;
