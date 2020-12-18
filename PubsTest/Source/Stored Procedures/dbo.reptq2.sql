SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[reptq2]
AS
SELECT CASE WHEN Grouping(type) = 1 THEN 'ALL' ELSE type END AS type,
  CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  Avg(ytd_sales) AS avg_ytd_sales
  FROM titles
  WHERE pub_id IS NOT NULL
  GROUP BY pub_id, type WITH ROLLUP;

GO
