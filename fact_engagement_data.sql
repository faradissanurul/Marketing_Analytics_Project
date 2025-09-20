SELECT
*
FROM dbo.engagement_data;

--**********************************************************************
--**********************************************************************

-- Query to clean and normalize the engagment_data table

SELECT
	EngagementID,		-- Select ID for each engagement
	ContentID,			-- Select ID for each content
	CampaignID,			-- Select ID for each campaign
	ProductID,			-- Select ID for each product
	UPPER(REPLACE(ContentType, 'Socialmedia' ,'Social Media')) AS ContentType,		-- Replace "Socialmedia" with "Social Media" and then converts all ContentType to uppercase
	LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) -1) AS Views,		-- Extract the Views part from the ViewClicksCombined column by taking the substring before the '-' character
	RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,	-- Extract the Clicks part from the ViewClicksCombined column by taking the substring after the '-' character
	Likes,				-- Select the number of likes the content received
	-- Convert the EngagementDate to mm.dd.yyyy format
	FORMAT(CONVERT(DATE, EngagementDate), 'MM.dd.yyyy') AS EngagementDate -- Convert and format the date as mm.dd.yyyy
FROM 
	dbo.engagement_data
WHERE
	ContentType != 'Newsletter';		-- Filter out rows where ContenType is 'Newsletter' as these are not relevant for the analysis