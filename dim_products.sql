SELECT 
*
FROM dbo.products;

--*****************************************************
--*****************************************************

-- Query to categorize products based on their price

SELECT
	ProductID,	-- Select ID of the products
	ProductName, -- Select name of the products
	Price,		 -- Select price of the products

	CASE		 -- Categorizes the products into price categories: Low, Medium, or High
		WHEN Price < 50 THEN 'Low'	-- If the price is less than 50, categorize as 'Low'
		WHEN Price BETWEEN 50 AND 200 THEN 'Medium' -- If the price is between 50 and 200, categorize as 'Medium'
		ELSE 'High'		-- If the price is greater than 200, categorize as 'High'
	END AS PriceCategory -- Name the new column as PriceCategory 

FROM dbo.products;		-- Source of table