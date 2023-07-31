DROP TABLE IF EXISTS fulfillment;
CREATE TABLE fulfillment(
	Product_Name VARCHAR(255),
	Warehouse_Order_Fulfillment_Day NUMERIC 
	);

Select *
FROM fulfillment;

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory(
	Product_Name VARCHAR(255),
	Year_Month text,
	Warehouse_Inventory NUMERIC, 	
	Inventory_Cost_Per_Unit NUMERIC,
	Year integer,
	month integer
);


SELECT *
FROM inventory;


DROP TABLE IF EXISTS orders_shipments;
CREATE TABLE orders_shipments(
	Order_ID INTEGER,
	Order_Item_ID INTEGER,
	Order_YearMonth DATE,
	Order_Year INTEGER,
	Order_Month INTEGER,
	Order_Day INTEGER,
	Order_Time TIME,
	Order_Quantity NUMERIC,	
	Product_Department VARCHAR(255),	
	Product_Category VARCHAR(255),	
	Product_Name VARCHAR(255),	 
	Customer_ID INTEGER, 	
	Customer_Market VARCHAR(100),	
	Customer_Region VARCHAR(100),	
	Customer_Country VARCHAR(100),	
	Warehouse_Country VARCHAR(100),	
	Shipment_Year INTEGER,	
	Shipment_Month INTEGER,	
	Shipment_Day INTEGER,	
	Shipment_Mode VARCHAR(50),	 
	Shipment_Days_Scheduled INTEGER, 	 
	Gross_Sales NUMERIC, 	 
	Discount_Percent NUMERIC, 	 
	Profit NUMERIC
);


copy orders_shipments (Order_ID, Order_Item_ID, Order_YearMonth, Order_Year, Order_Month, Order_Day, Order_Time, Order_Quantity, Product_Department, Product_Category, Product_Name, Customer_ID, Customer_Market, Customer_Region, Customer_Country, Warehouse_Country, Shipment_Year, Shipment_Month, Shipment_Day, Shipment_Mode, Shipment_Days_Scheduled, Gross_Sales, Discount_Percent, Profit) 
FROM 'D:\Supply Chain Analytics\orders_and_shipments_dataset.csv' DELIMITER ',' CSV HEADER;






SELECT *
FROM orders_shipments;
