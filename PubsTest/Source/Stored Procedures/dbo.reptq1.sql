SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[reptq1]
AS
SELECT CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  Avg(price) AS avg_price
  FROM titles
  WHERE price IS NOT NULL
  GROUP BY pub_id WITH ROLLUP
  ORDER BY pub_id;

GO
