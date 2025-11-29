drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY ,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
DiscountPercent NUMERIC(5,2),
AvailableQuantity INTEGER ,
DiscountSellingPrice NUMERIC (8,2),
weightInGms INTEGER,
OutOfStock BOOLEAN,
quantity INTEGER
);


--data exploration--

--count of rows 

SELECT COUNT(*) from zepto;

--sample data 
SElECT * from zepto
LIMIT 10;


-- CHECKING null values 
SELECT * from zepto 
WHERE 
name IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR 
discountpercent IS NULL
OR 
discountsellingprice IS NULL
OR 
weightingms IS NULL
OR 
outofstock IS NULL
OR 
quantity IS NULL
OR 
availablequantity IS NULL;

-- different product categories 
SELECT DISTINCT category 
FROM zepto 
ORDER BY category;

--products in stock vs products out of stock 
SELECT outofstock , count(sku_id)
FROM zepto 
GROUP BY outofstock ;


--product names present_multiple times 
SELECT name , COUNT(sku_id) as "Number of SKUs"
FROM zepto 
GROUP BY name 
HAVING count(sku_id) > 1 
ORDER BY count(sku_id) DESC;


--data cleaning 

--product with price = 0

SELECT * from zepto 
WHERE mrp=0 OR discountsellingprice = 0;


DELETE from zepto WHERE mrp = 0 ;


--convert paise to rupees 
UPDATE zepto 
SET mrp = mrp / 100.0 ,
discountsellingprice =  discountsellingprice/100.0;

SELECT mrp,discountsellingprice from zepto 


--BUSINESS INSIGHTS 
--1. Find the top 10 best - value products based on the discount percentage .

SELECT DISTINCT name , mrp , discountpercent 
from zepto 
ORDER BY discountpercent DESC
LIMIT 10 ;

-- 2. What are the products with High MRP but Out of stock 
SELECT DISTINCT name , mrp , outofstock 
FROM zepto 
WHERE outofstock = TRUE and mrp > 300 
ORDER BY mrp DESC ;

--3. Calculate Estimated Revenue for each category 
SELECT category, 
SUM(discountsellingprice * availablequantity) AS "total_revenue"
FROM zepto 
GROUP BY category 
ORDER BY total_revenue; 

--4.Find all products where MRP is greater than Rs.500 and discount is less than 10%
SELECT DISTINCT name ,mrp ,discountpercent
FROM zepto 
WHERE mrp > 500 and discountpercent < 10 
ORDER BY mrp DESC , discountpercent DESC;


--5. Indentify the top 5 categories offering the highest average discount percent 
SELECT category , 
ROUND(AVG(discountpercent),2) AS "avg_discountpercent"
FROM zepto 
GROUP BY category
ORDER BY avg_discountpercent DESC
LIMIT 5;


--6. Find the price per gram for products above 100g and sort by best value 
SELECT DISTINCT name , weightingms , discountsellingprice , 
ROUND(discountsellingprice / weightingms,2) AS price_per_gram
FROM zepto 
WHERE weightingms >= 100
ORDER BY price_per_gram;

--7. Group the products into categories like Low , Medium , Bulk. 
SELECT DISTINCT name , weightingms , 
CASE WHEN weightingms < 1000 THEN 'Low'
 	 WHEN weightingms > 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category 
FROM zepto;


--8. What is the total inventory per category 
SELECT category, 
SUM(weightingms * availablequantity ) AS total_weight
FROM zepto 
GROUP BY category 
ORDER BY total_weight;