SELECT
*
FROM dbo.customers

SELECT
*
FROM dbo.geography

--**********************************************************************
--**********************************************************************

-- SQL statement to join dim_customers with dim_geography to enrich customer data with geographic information

SELECT 
	c.CustomerID,		-- Select ID of the customers
	c.CustomerName,		-- Select name of the customers
	c.Email,			-- Select email of the customers
	c.Gender,			-- Select gender of the customers
	c.Age,				-- Select age of the customers
	g.Country,			-- Select country from geography table to enrich customer data
	g.City				-- Select city from geography table to enrich customer data
FROM 
	dbo.customers c		-- Specifies the alias 'c' for the dim_customers table
LEFT JOIN
	dbo.geography g		-- Specifies the alias 'g' for the dim_geography table
ON
	c.GeographyID = g.GeographyID; -- Join the two tables on the Geography ID field to match customers with their geographic information
