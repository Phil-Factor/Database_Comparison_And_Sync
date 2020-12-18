CREATE TYPE [dbo].[empid] FROM char (9) NOT NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[empid] TO [public]
GO
