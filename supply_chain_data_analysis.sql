SELECT *
FROM fulfillment;

SELECT *
FROM inventory;

SELECT *
FROM orders_shipments;


--Part A. Order Fulfillment Efficiency:

--1. What is the average order fulfillment day for each product, 
-- and how does it vary across different product categories and regions?
SELECT os.product_name,
	   os.product_category,
	   os.customer_region,
	   os.order_year AS order_date,
	   ROUND(AVG(f.warehouse_order_fulfillment_day),2) AS avg_order_fulfillment_day
FROM orders_shipments os
JOIN fulfillment f ON os.product_name = f.product_name
GROUP BY 1,2,3,4
ORDER BY 2,3,5;


-- Part B.Customer Analysis:
-- 1. Which customers have the highest total sales (Gross Sales) or profit generated (Profit)?
SELECT customer_id,
       customer_market,
	   customer_region,
	   customer_country,
	   SUM(gross_sales) AS total_sales,
	   SUM(profit) AS total_profit
FROM orders_shipments
GROUP BY 1,2,3,4
ORDER BY 5 DESC,6 DESC;


-- 2. How does customer market (geographic grouping) impact the average order quantity and discount percentage?
SELECT customer_market,
       ROUND(AVG(order_quantity),2) AS Average_order_quantity,
	   ROUND(AVG(discount_percent),3) AS Average_discount_percentage
FROM orders_shipments
GROUP BY 1;

-- 3. What are the top product categories and product names preferred by different customer markets or regions?
WITH market_category_sales AS(
	SELECT os.customer_market,
		   os.customer_region,
		   os.product_category,
		   SUM(os.gross_sales) AS total_sales
	FROM orders_shipments os
	GROUP BY 1,2,3),

top_product_categories AS(
	SELECT mc.customer_market,
		   mc.customer_region,
		   mc.product_category,
	       mc.total_sales,
		   RANK() OVER (PARTITION BY mc.product_category ORDER BY mc.total_sales DESC) AS ranking
	FROM market_category_sales mc
	GROUP BY 1,2,3,4)
	
SELECT tpc.customer_market,
       tpc.customer_region,
	   tpc.product_category,
	   tpc.total_sales,
	   os.product_name,
	   os.gross_sales
FROM top_product_categories tpc
JOIN orders_shipments os ON os.customer_market = tpc.customer_market 
AND os.product_category = tpc.product_category
WHERE tpc.ranking = 1;

-- 4. What is the revenue change over time?
WITH revenue_change_over_time AS(
	SELECT order_year AS order_date,
		   product_category,
		   SUM(gross_sales) AS revenue
	FROM orders_shipments
	GROUP BY 1,2)

SELECT order_date,
	   product_category,
       revenue,
	   LAG(revenue) OVER (ORDER BY order_date) AS previous_revenue,
       (revenue - LAG(revenue) OVER (ORDER BY order_date)) AS revenue_change
FROM revenue_change_over_time;



-- Part C.Product Analysis:
-- 1. What are the top-selling products in each product category, and how have their sales trended over time?
WITH product_sales AS(
	SELECT os.product_name,
		   os.product_category,
		   os.order_year AS order_date,
		   SUM(os.gross_sales) AS total_sales
	FROM orders_shipments os
	GROUP BY 1,2,3
	ORDER BY 1,2,3),
top_sales_products AS(
	SELECT ps.*,
		   RANK() OVER (PARTITION BY ps.product_category ORDER BY ps.total_sales) AS sales_rank
	FROM product_sales ps)
	
SELECT tsp.*
FROM top_sales_products tsp
WHERE sales_rank = 1;

-- 2. What are the top-selling products by quantity in each product category?
SELECT product_name,
       product_category,
	   order_year AS order_date,
	   SUM(order_quantity) AS total_quantity_sold
FROM orders_shipments
GROUP BY 1,2,3
ORDER BY 4 DESC;

-- Part D.Inventory Analysis:
-- 1. Which products have the highest inventory levels on a yearly basis?
WITH ranked_inventory AS (
    SELECT
			product_name,
			year,
			warehouse_inventory,
			RANK() OVER (PARTITION BY year ORDER BY warehouse_inventory DESC) AS inventory_rank_high
    FROM inventory)

SELECT
		product_name,
		year,
		warehouse_inventory
FROM ranked_inventory
WHERE inventory_rank_high = 1;


--2. How does the inventory cost per unit vary across different product categories and regions?
SELECT product_category,
       os.customer_region,
	   ROUND(AVG(inventory_cost_per_unit),2) AS Average_inventory_cost_per_unit
FROM inventory i 
JOIN orders_shipments os ON os.product_name = i.product_name
GROUP BY 1,2
ORDER BY 2;
      
-- Part E.Shipment Analysis:
--1. What are the most popular products category shipped using each shipment mode?
SELECT order_yearmonth AS order_date,
	   product_name,
       product_category,
	   shipment_mode,
	   COUNT(*) AS shipment_count
FROM orders_shipments 
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

--2. How does the average shipment days vary for different products under each shipment mode?
SELECT product_name,
	   product_category,
	   shipment_mode,
	   ROUND(AVG(shipment_days_scheduled),2) AS average_shipment_day
FROM orders_shipments
GROUP BY 1,2,3
ORDER BY 2,3,4 DESC;


-- 3. Are there any shipment delays that occur more frequently in certain shipment modes or regions?
SELECT shipment_mode,
       customer_market,
	   customer_region,
	   COUNT(*) AS shipment_delays
FROM orders_shipments
WHERE shipment_days_scheduled < 0
GROUP BY 1,2,3;









