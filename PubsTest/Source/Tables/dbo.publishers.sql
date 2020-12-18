CREATE TABLE [dbo].[publishers]
(
[pub_id] [char] (4) COLLATE Latin1_General_CI_AS NOT NULL,
[pub_name] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[city] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[state] [char] (2) COLLATE Latin1_General_CI_AS NULL,
[country] [nvarchar] (80) COLLATE Latin1_General_CI_AS NULL DEFAULT ('USA')
)
GO
ALTER TABLE [dbo].[publishers] ADD CHECK (([pub_id]='1756' OR [pub_id]='1622' OR [pub_id]='0877' OR [pub_id]='0736' OR [pub_id]='1389' OR [pub_id] like '99[0-9][0-9]'))
GO
ALTER TABLE [dbo].[publishers] ADD CONSTRAINT [UPKCL_pubind] PRIMARY KEY CLUSTERED  ([pub_id])
GO
