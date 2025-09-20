SELECT
*
FROM dbo.customer_journey;

--**********************************************************************
--**********************************************************************

-- Common Table Expression (CTE) to identify and tag duplicate records

WITH DuplicateRecords AS (
	SELECT
		JourneyID,		-- Select ID for each journey
		CustomerID,		-- Select ID for each customer
		ProductID,		-- Select ID for each product
		VisitDate,		-- Select the date of the visit, which helps in determining the timeline of customer interaction
		Stage,			-- Select the stage of the customer journey
		Action,			-- Select the action taken by customer (e.g., View, Click, Purchase, etc)
		Duration,		-- Select the duration of the action or interaction
		-- Identify duplicate records by using ROW_NUMBER() within the partition defined below
		ROW_NUMBER() OVER (
			-- PARTITION BY groups the rows based on on the specified columns that should be unique
			PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
			-- ORDER BY defines how to order the rows within each partition (usually by a unique identifier like JourneyID)
			ORDER BY JourneyID
		) AS row_num	-- This creates a new column 'row_num' that numbers each row within its partition
	FROM dbo.customer_journey -- Source of table
)

-- Select all records from CTE where row_num > 1, which indicates duplicate entries

SELECT *
FROM DuplicateRecords
WHERE row_num > 1		-- Filter out the first occurence (row_num = 1) and only show the duplicates (row_num > 1)
ORDER BY JourneyID;

-- Outer query selects the final cleaned and standarized data

SELECT
	JourneyID,			-- Select ID for each journey
	CustomerID,			-- Select ID for each customer
	ProductID,			-- Select ID for each product
	VisitDate,			-- Select the date of the visit 
	Stage,				-- Select the stage of the customer journey
	Action,				-- Select the action taken by customer (e.g., View, Click, Purchase, etc)
	COALESCE(Duration, avg_duration, global_avg_duration) AS Duration		-- Replace missing durations with the average duration for the corresponding date and the global average duration for the one is missing on coressponding date			
FROM 
	(
		SELECT
			JourneyID,	-- Select ID for each journey
			CustomerID,	-- Select ID for each customer
			ProductID,	-- Select ID for each product
			VisitDate,	-- Select the date of the visit
			UPPER(Stage) AS Stage,	-- Convert Stage values to uppercase for consistency data analysis
			Action,		-- Select the action taken by customer (e.g., View, Click, Purchase, etc)
			Duration,	-- Select the duration of the action or interaction
			AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,	-- Calculate the average duration for each date, using only numeric values
			AVG(Duration) OVER () global_avg_duration,						-- Calculate the global average duration
			ROW_NUMBER() OVER (
				PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action		-- Groups by these columns to identify duplicate records
				ORDER BY JourneyID		-- Orders by JourneyID to keep the first occurence of each duplicate
			) AS row_num		-- Assigns a row number to each row within the partition to identify duplicates
		FROM 
			dbo.customer_journey	-- Source table
	) AS subquery		-- Names the subquery for reference in the outer query
WHERE row_num = 1;		-- Keeps only the first occurence of each duplicate group identified in the subquery