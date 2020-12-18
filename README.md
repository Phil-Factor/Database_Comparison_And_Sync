# Database_Comparison_And_Sync
## PowerShell wrapping of SQL Compare and SQL Data Compare

When you're working on a database, working with SQL Compare and SQL Data Compare User Interface can be a distraction, especially if you are asking it to do the same task over and over again. I’ve written a PowerShell Cmdlet called  Run-DatabaseScriptComparison to demonstrate a way of doing this.  

When you start automating SQL Compare and SQL Data Compare by using the Command-Line Interface (CLI) of these apps, you'll find that it is much easier, but still needs occasional changes are your requirements evolve. A Cmdlet is ideal for this, because you can fix it to do what you want but allow for different varieties of tasks by parameterising a lot of the variables such as the locations where you store 'artifacts' and what you want to store. 
