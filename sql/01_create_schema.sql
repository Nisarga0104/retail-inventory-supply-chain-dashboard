-- Retail Order Management & Business Analytics Database
-- MySQL 8.0+ | Run this script in MySQL Workbench.
-- After creating tables, import matching CSVs using Table Data Import Wizard.
CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS purchase_orders;
DROP TABLE IF EXISTS inventory_snapshots;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  city VARCHAR(60),
  registration_date DATE
);
CREATE TABLE stores (
  store_id INT PRIMARY KEY,
  store_name VARCHAR(50) NOT NULL,
  region VARCHAR(30),
  city VARCHAR(60)
);
CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(100) NOT NULL,
  lead_time_days INT NOT NULL,
  supplier_region VARCHAR(30),
  CHECK (lead_time_days >= 0)
);
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  supplier_id INT NOT NULL,
  unit_cost DECIMAL(10,2) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  reorder_level INT NOT NULL DEFAULT 20,
  CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  CHECK (unit_cost >= 0 AND unit_price >= 0 AND reorder_level >= 0)
);
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT NOT NULL,
  store_id INT NOT NULL,
  order_date DATE NOT NULL,
  order_status ENUM('Delivered','Cancelled','Returned','Processing') NOT NULL,
  CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_order_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
  INDEX idx_orders_date (order_date),
  INDEX idx_orders_status (order_status)
);
CREATE TABLE order_items (
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  discount_pct DECIMAL(5,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (order_id, product_id),
  CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(product_id),
  CHECK (quantity > 0 AND unit_price >= 0 AND discount_pct BETWEEN 0 AND 1)
);
CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  order_id INT NOT NULL UNIQUE,
  payment_method VARCHAR(30),
  payment_status ENUM('Paid','Refunded') NOT NULL,
  payment_date DATE,
  CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
CREATE TABLE shipments (
  order_id INT PRIMARY KEY,
  ship_date DATE,
  promised_date DATE,
  delivered_date DATE,
  delay_days INT NOT NULL DEFAULT 0,
  shipment_status ENUM('Delivered','Returned') NOT NULL,
  CONSTRAINT fk_shipment_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CHECK (delay_days >= 0)
);
CREATE TABLE inventory_snapshots (
  snapshot_date DATE NOT NULL,
  store_id INT NOT NULL,
  product_id INT NOT NULL,
  opening_units INT NOT NULL,
  received_units INT NOT NULL,
  sold_units INT NOT NULL,
  closing_units INT NOT NULL,
  PRIMARY KEY (snapshot_date, store_id, product_id),
  CONSTRAINT fk_inv_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
  CONSTRAINT fk_inv_product FOREIGN KEY (product_id) REFERENCES products(product_id),
  CHECK (opening_units >= 0 AND received_units >= 0 AND sold_units >= 0 AND closing_units >= 0)
);
CREATE TABLE purchase_orders (
  purchase_order_id INT PRIMARY KEY,
  supplier_id INT NOT NULL,
  store_id INT NOT NULL,
  product_id INT NOT NULL,
  order_date DATE NOT NULL,
  quantity INT NOT NULL,
  expected_lead_days INT NOT NULL,
  actual_lead_days INT NOT NULL,
  po_status ENUM('Received','Delayed') NOT NULL,
  CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  CONSTRAINT fk_po_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
  CONSTRAINT fk_po_product FOREIGN KEY (product_id) REFERENCES products(product_id),
  CHECK (quantity > 0 AND expected_lead_days >= 0 AND actual_lead_days >= 0),
  INDEX idx_po_supplier (supplier_id)
);

-- Import CSVs into tables in this order:
-- suppliers, customers, stores, products, orders, order_items, payments,
-- shipments, inventory_snapshots, purchase_orders.
