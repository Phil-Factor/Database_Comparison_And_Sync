CREATE TABLE [dbo].[jobs]
(
[job_id] [smallint] NOT NULL IDENTITY(1, 1),
[job_desc] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('New Position - title not formalized yet'),
[min_lvl] [tinyint] NOT NULL,
[max_lvl] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[jobs] ADD CHECK (([max_lvl]<=(250)))
GO
ALTER TABLE [dbo].[jobs] ADD CHECK (([min_lvl]>=(10)))
GO
ALTER TABLE [dbo].[jobs] ADD PRIMARY KEY CLUSTERED  ([job_id])
GO
