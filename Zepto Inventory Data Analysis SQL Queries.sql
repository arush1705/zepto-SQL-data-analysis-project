DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT count(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE category IS NULL 
OR
name IS NULL 
OR
 mrp IS NULL 
OR
discountpercent IS NULL 
OR
availablequantity IS NULL 
OR
discountedsellingprice IS NULL 
OR
weightingms IS NULL 
OR
outofstock IS NULL
OR
quantity IS NULL; 

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product in stock vs out of stock
SELECT outofstock, COUNT(*) FROM zepto
GROUP BY outofstock;

--product names present multiple times
SELECT name,COUNT(sku_id) AS  "Number of SKUs" FROM zepto GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

--data cleaning
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;

SELECT * FROM zepto
LIMIT 10;

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountpercent FROM zepto ORDER BY discountpercent DESC LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name, mrp FROM ZEPTO 
WHERE outofstock = 'true'
AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category, SUM(discountedsellingprice * availablequantity) AS "Total Revenue" FROM zepto 
GROUP BY category ORDER BY SUM(discountedsellingprice * availablequantity) DESC;

-- Q4. Find all products where MRP is greater than <500 and discount is less than 10%.
SELECT name, mrp, discountpercent FROM zepto WHERE mrp > 500 AND discountpercent < 10 
ORDER BY mrp DESC, discountpercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, AVG(discountpercent) AS "Average Discount" FROM zepto 
GROUP BY category ORDER BY AVG(discountpercent) DESC LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT name, weightingms, discountedsellingprice, ROUND((discountedsellingprice/weightingms),2) AS "Price per Gram" FROM zepto
WHERE weightingms > 100 ORDER BY "Price per Gram" ;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
	 ELSE 'Bulk' END
	 AS "Weight Category" 
FROM zepto;	 
-- Q8.What is the Total Inventory Weight Per Category
SELECT category, SUM(weightingms*quantity) AS "Total Weight" FROM zepto 
GROUP BY category ORDER BY SUM(weightingms*quantity) DESC;




