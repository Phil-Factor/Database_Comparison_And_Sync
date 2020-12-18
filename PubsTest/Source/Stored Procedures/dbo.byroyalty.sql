SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[byroyalty] @percentage INT
AS
SELECT au_id FROM titleauthor WHERE titleauthor.royaltyper = @percentage;

GO
