SELECT
*
FROM dbo.customer_reviews

--**********************************************************************
--**********************************************************************

-- Query to clean whitespace issue in the ReviewText column

SELECT
	ReviewID,		-- Select ID for each review
	CustomerID,		-- Select ID for each customer
	ProductID,		-- Select ID for each product
	ReviewDate,		-- Select the date when the review was written
	Rating,			-- Select the numerical rating given by the customer (e.g., 1 to 5 stars) )
	REPLACE(ReviewText, '  ', ' ') AS ReviewText -- Clean up the ReviewText by replacing double spaces with single spaces to ensure the text is more readable and standarized
FROM dbo.customer_reviews;