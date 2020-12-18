# Database_Comparison_And_Sync
## PowerShell wrapping of SQL Compare and SQL Data Compare

When you're working on a database, working with SQL Compare and SQL Data Compare User Interface can be a distraction, especially if you are asking it to do the same task over and over again. I’ve written a PowerShell Cmdlet called  Run-DatabaseScriptComparison to demonstrate a way of doing this.  

When you start automating SQL Compare and SQL Data Compare by using the Command-Line Interface (CLI) of these apps, you'll find that it is much easier, but still needs occasional changes are your requirements evolve. A Cmdlet is ideal for this, because you can fix it to do what you want but allow for different varieties of tasks by parameterising a lot of the variables such as the locations where you store 'artifacts' and what you want to store. 

This Cmdlet is designed to support ...

1.	Saving database changes to source control
Save any alterations to the schema or the data of your dev database to a script directory, to then save it to your branch of the code

2.	Copying a database
Making an identical copy of a database on the same server or another one, perhaps remote or cloud-based

3.	Updating a database with changes from source
Make a database identical to a source directory, scripting both the schema and, if you wish, the database data

4.	Generating the latest change scripts
For the schema and data, for you or someone else to check

5.	Generating a build script for the source
To do a clean build of a new database versions, such as for integration testing
