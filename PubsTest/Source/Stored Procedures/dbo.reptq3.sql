SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[reptq3] @lolimit MONEY, @hilimit MONEY, @type CHAR(12)
AS
SELECT CASE WHEN Grouping(pub_id) = 1 THEN 'ALL' ELSE pub_id END AS pub_id,
  CASE WHEN Grouping(type) = 1 THEN 'ALL' ELSE type END AS type,
  Count(title_id) AS cnt
  FROM titles
  WHERE price > @lolimit
    AND price < @hilimit
    AND type = @type
     OR type LIKE '%cook%'
  GROUP BY pub_id, type WITH ROLLUP;

GO
