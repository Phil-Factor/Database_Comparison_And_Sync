CREATE TABLE [dbo].[roysched]
(
[roysched_id] [int] NOT NULL IDENTITY(1, 1),
[title_id] [dbo].[tid] NOT NULL,
[lorange] [int] NULL,
[hirange] [int] NULL,
[royalty] [int] NULL
)
GO
ALTER TABLE [dbo].[roysched] ADD PRIMARY KEY CLUSTERED  ([roysched_id])
GO
CREATE NONCLUSTERED INDEX [titleidind] ON [dbo].[roysched] ([title_id])
GO
ALTER TABLE [dbo].[roysched] ADD FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
GO
