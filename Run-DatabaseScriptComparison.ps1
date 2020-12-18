function global:Run-DatabaseScriptComparison
{

<#
	.SYNOPSIS
		This runs SQL Compare and SQL Data Compare against a database and script
	
	.DESCRIPTION
		This Cmdlet will create, or updata a scripts folder and producxe build scripts. It will update a database or produce deployment scripts to do so
	
	.PARAMETER MyServerInstance
		The name of the SQL Server or instance.

	.PARAMETER MyDatabase
		The Name of the Database.

	.PARAMETER MyScripts
		The name of the scripts folder.

	.PARAMETER IWantTheDataPlease
		this defaults to true unless you set it to false
	
	.PARAMETER IWantToSynchPlease
		this defaults to true unless you set it to false
	
	.PARAMETER MyVersion
		#if you want the build and synch scripts to be given a version number in the name
		#blank (not null) if you don't
	
	.PARAMETER SourceFolder
		the path to the folder where the Redgate Script folder is stored
	
	.PARAMETER ScriptDirectory
		the path to the folder where the Redgate Script folder is stored
	
	.PARAMETER DatabaseDirectory
		the path to the folder where the database folder is stored
	
	.PARAMETER MyDatabasePath
		The SQL Compare Scripts object-level Folder used
	
	.PARAMETER MyScriptsPath
		the path to the folder where you wish to store the scripts
	
	.PARAMETER MyExportPath
		the path to the folder where you wish to store the exported data

	.PARAMETER MyReportPath
		the path to the folder where all the reports are written

	.PARAMETER MyJSONExportPath
		
		the path to the folder where you want the JSON scripts to go 

	.PARAMETER MybuildScriptPath
		the path to the folder where you wish to store the build scripts
	
	.EXAMPLE
Run-DatabaseScriptComparison -MyServerInstance 'MyServer'  -MyDatabase 'pubstest' -UserName PhilFactor

Run-DatabaseScriptComparison -MyServerInstance 'MyServer'  -MyDatabase 'pubsTwo' -UserName PhilFactor -sourcetype 'script'

Run-DatabaseScriptComparison -MyServerInstance 'MyServer'  -MyDatabase 'pubstest' -UserName PhilFactor -MyVersion '_1-2-5'
	
	.NOTES
		This is a wrapper around the SQL Compare and SQL Data compare when comparisons are being done
between scripts and databases
#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$MyServerInstance,
		[Parameter(Mandatory = $true)]
		[string]$MyDatabase,
		#the name of the database

		[string]$MyScripts=$MyDatabase,
		#the name of the script folder
		
		[string]$UserName=$null,
		# the username for the database. You might be asked for a password 

		$IWantTheDataPlease=$true,
		#do you want the data included with the save or synch?

		$IWantToSynchPlease = $true,
		#do you want the databases synched or just scripted?

		$SourceType='database',
		# specify either 'database' or 'scripts' as the source 
		
		$MyVersion='',
		#if you want the build and synch scripts to be given a version number in the name
		#blank (not null) if you don't
		
		$SourceFolder= "$($env:HOMEDRIVE)$($env:HOMEPATH)\Documents\GitHub",
		#the the path to the source control Folder

		$ScriptDirectory= "$Sourcefolder\$MyScripts",
		#the path to the folder where the Redgate Script folder is stored
		
		$DatabaseDirectory = "$Sourcefolder\$MyDatabase",
		#the path to the folder where the database folder is stored
		
		$MyDatabasePath = "$ScriptDirectory\Source" ,
		#The SQL Compare Scripts object-level Folder used
		
		$MyScriptsPath='',
		#the path to the folder where you wish to store the scripts
		
		$MyExportPath = '',
		#the path to the folder where you wish to store the exported data

		$MyReportPath = '',
		#the path to the folder where all the reports are written

		$MyJSONExportPath = '',
		#the path to the folder where you want the JSON scripts to go 

		$MybuildScriptPath = ''
		#the path to the folder where you wish to store the build scripts
	)

<#We start by setting all the parameters. We need to be able to identify and contact the database,
and we also need to know where the source code is kept#>
	$Source = '1'; $Target = '2' #never alter these, they are constants.
	if ($SourceType -eq 'Database')
	{ $Dbs = $Source }
	else { $Dbs = $Target } #the database (Dbs) is either $source or $Target. 
	if ($Dbs -eq $Target) #decide where the reports, data and other stuff goes
	{
		$whereWePutThePaperwork = $DatabaseDirectory
	}
	else
	{
		$whereWePutThePaperwork = $ScriptDirectory
	}
	
	if ($MyReportPath -eq '')
	{ $MyReportPath = "$whereWePutThePaperwork\Reports" } #where the reports go for the process
	if ($MyScriptsPath -eq '')
	{ $MyScriptsPath = "$whereWePutThePaperwork\Scripts" } #set to null if you don't want this
	if ($MyExportPath -eq '')
	{ $MyExportPath = "$whereWePutThePaperwork\Data" } #set to null if you don't want this
	if ($MyJSONExportPath -eq '')
	{ $MyJSONExportPath = "$whereWePutThePaperwork\JSONData" } #set to null if not wanted
	if ($MybuildScriptPath  -eq '')
	{ $MybuildScriptPath = "$whereWePutThePaperwork\Scripts" } #set to null if you don't want this
	
	<# now we work out what we are doing so we can give a status report #>
	$SourceAndTarget = @("Database '$MyServerInstance.$MyDatabase'", "Script Folder '$MyScripts'")
	$scr = switch ($Dbs) { $Source{ $Target} $Target{ $Source} } #work out if script is 1 0r 2 
	$SourceName = $SourceAndTarget[$dbs - 1] #SQL Compare uses 1 in a param to indicate source
	$TargetName = $SourceAndTarget[$Scr - 1] #and 2 indicates a target
	$SourceAndTarget = "using $sourcename as source and $TargetName as target"
	
	$SoFarSoGood = $true; #This is set to false if a warning or error ought to stop processing
	$SQLCompare = "${env:ProgramFiles(x86)}\Red Gate\SQL Compare 14\sqlcompare.exe" # full path
	$SQLDataCompare = "${env:ProgramFiles(x86)}\Red Gate\SQL Data Compare 14\sqlDatacompare.exe" # full path
<# this makes commandline scripting easier and more intuitive #>

Write-Verbose  "-ServerName=$MyServerInstance'#the server where the database is
-MyDatabase='$MyDatabase'   #The name of the database
-dbs='$dbs' #either 1(source) or 2(target) whether database is target or source
-MyScripts='$MyScripts' #name for the script folder
-UserName='$UserName' #only use this if you are using SQL Server security and need credentials
-IWantTheDataPlease='$IWantTheDataPlease' #Do you want the data to be done too
-IWantToSynchPlease='$IWantToSynchPlease' #Do you want to see and use the scripts
-SourceType='$SourceType' # is the source a database or a script directory
-MyVersion='$MyVersion' #blank (not null) if you don't want to add any version info to reports and scripts
-SourceFolder='$SourceFolder' #the base folder for the source
-ScriptDirectory='$ScriptDirectory' #the path to our script folder
-DatabaseDirectory='$DatabaseDirectory' #the name of our base path to the database folder
-MyDatabasePath='$MyDatabasePath' #path to the Compare Scripts object-level Folder
-MyScriptsPath='$MyScriptsPath' #Path to The SQL Compare Scripts and data object-level Folder
-MyExportPath='$MyExportPath' #Path to data Folder where the entire data is written as CSV
-MyReportPath='$MyReportPath' #Path to where the reports are sent
-MyJSONExportPath='$MyJSONExportPath'#Path to The JSON data scripts
-MybuildScriptPath='$MybuildScriptPath'#Path to where the database and data build and synch scripts are kept"

<#  Now we deal with connections that require passwords such as SQL Servers in containers or SQL 
Servers outside a domain #>
	$SQLServerCredential = 'Trusted_Connection=Yes;';
	$MyUserID = $null; $MyPassword = $null
    if ($username.Length -eq 0) {$UserName=$null}
	if ($UserName.Length -gt 0)
	{
	[void][Windows.Security.Credentials.PasswordVault, Windows.Security.Credentials, ContentType = WindowsRuntime]
	$Vault = New-Object Windows.Security.Credentials.PasswordVault
		New-Object Windows.Security.Credentials.PasswordVault
		try { $CredentialObject = $vault.Retrieve($MyServerInstance, $username) | Select-Object -First 1 }
		catch
		{
			$Credential = Get-Credential -Message "please provide your password for '$MyServerInstance'" -UserName $UserName
			$CredentialObject = New-Object Windows.Security.Credentials.PasswordCredential -ArgumentList ($MyServerInstance, $Credential.UserName, $Credential.GetNetworkCredential().Password)
			$vault.Add($CredentialObject)
			Remove-Variable Credential
		}
		$SQLServerCredential = "Uid=$($UserName);Pwd=$($CredentialObject.Password);"
		$MyUserID = $UserName; $MyPassword = $CredentialObject.Password;
		@('CredentialObject', 'vault') | foreach{ Remove-Variable $_ }
	}
	$ConnectionString =
	"Driver={ODBC Driver 17 for SQL Server};Server=$MyServerInstance;Database=$MyDatabase;$SQLServerCredential";
    #we don't use the connection string ---yet! (any additional scripting)
<# Just in case we have an error in either SQL Compare or SQL Data Compare, we do a lookup for the 
reason.  The errors codes are shared by both #>
	$ErrorMeanings =
	@{
		"0" = "Success"; "1" = "General error"; "3" = "Illegal argument duplication"
		; "8" = "Unsatisfied argument dependency";; "32" = "Value out of range"
		; "33" = "Value overflow"; "34" = "Invalid value"; "35" = "Invalid license"
		; "61" = "Deployment warnings"; "62" = "High level parser error"
		; "63" = "Databases identical"; "64" = "Command line usage error"
		; "65" = "Data error"; "69" = "Resource unavailable"
		; "70" = "An unhandled exception occurred"; "73" = "Failed to create report"
		; "74" = "I/O error"; "77" = "Insufficient permission"; "79" = "Databases not identical"
		; "126" = "SQL Server error"; "130" = "Ctrl-Break"; "400" = "Bad request"
		; "402" = "Not licensed"; "499" = "Activation cancelled by user"; "500" = "Unhandled exception"
	}
<# We check to make sure that both the database path and the report path both exist #>
	if (-not (Test-Path -PathType Container $MyReportPath))
	{
		# not there, so we create the report directory 
		$null = New-Item -ItemType Directory -Force -Path $MyReportPath;
	}
	
	if (-not (Test-Path -PathType Container $MyDatabasePath))
	{
		#if it isnt there we can get SQL Data Compare to do the whole task 
		# not there so we create the script directory (normally you get this from the VCS)
		$null = New-Item -ItemType Directory -Force -Path $MyDatabasePath;
	}
<# We first do a synchronization/deployment between the source and target
 Now we deal with the parameters for source and target for SQL Compare 
 we do this by blatting an array of parameters. You can also splat a hashtable
 but we are changing parameters dynamically  #>
	
	$AllArgs = @()
	if ($MyUserId -ne $NULL) { $AllArgs += "/username$($dbs):$MyUserId" }
	if ($MyPassword -ne $NULL) { $AllArgs += "/Password$($dbs):$MyPassword" }
<# Now we can update the target with any changes. We can change source and target
dynamically #>
	$AllArgs += @("/server$($dbs):$MyServerInstance", "/database$($dbs):$MyDatabase ",
		"/scripts$($scr):$MyDatabasePath", '/q', '/force','/include:Identical','/Options:Default,iscn')
	if ($IWantToSynchPlease) { $AllArgs += @('/synch') }
	if ($MyReportPath -ne $null)
	{ $AllArgs += @("/report:$MyReportPath\$MyDatabase$MyVersion.html", "/reportType:Simple", "/rad") }
	if ($MyScriptsPath -ne $null)
	{
		if (-not (Test-Path -PathType Container $MyScriptsPath))
		{
			# not there, so we create the report directory 
			$null = New-Item -ItemType Directory -Force -Path $MyScriptsPath;
		}
		#you can of course alter the naming convention here	for the namr of the migration script file
		$AllArgs += @("/scriptfile:$MyScriptsPath\$($MyDatabase)SynchScript$MyVersion.SQL")
	}
    $AllArgs|foreach{Write-verbose $_} 
	&$SQLCompare @AllArgs >"$MyReportPath\$MyDatabase$MyVersionReport.txt" #now we actually execute SQL Compare
	if ($?) { "successfully Synched $SourceAndTarget" }
	else
	{
		#if there was an error of some sort
		if ($LASTEXITCODE -eq 63) { 'Database and scripts were identical' }
		else
		{
			$SoFarSoGood = $false;
			$SQLCompareError = "SQK Compare had an error during Synch $SourceAndTarget! (code $LASTEXITCODE) - $(
				$ErrorMeanings."$lastexitcode")"
			Write-Error $SQLCompareError
		}
	}
<#do we also need a build script from the source? If so we need to do a second pass with 
SQL Compare to create an entire executable build script. I like these as a reference and 
also a way of doing certain database development operations such as wide changes such as
an extensive renaming. #>
	
	if ($MybuildScriptPath -ne $null -and $SoFarSoGood) #if a build script is requested...
	{
		#create the path if it doesn't already exist
		if (-not (Test-Path -PathType Container $MybuildScriptPath))
		{
			# not there, so we create the report directory 
			$null = New-Item -ItemType Directory -Force -Path $MybuildScriptPath;
		}
		$AllArgs = @()
	<# we might be getting this from a script or a database #>
		if ($dbs -eq '1' -and $MyUserId -ne $NULL) { $AllArgs += "/username1:$MyUserId" }
		if ($dbs -eq '1' -and $MyPassword -ne $NULL) { $AllArgs += "/Password1:$MyPassword" }
    <# Now we can create the parameter array to update the target with any changes #>
		if ($dbs -eq '1') #if we are scripting out a database ...
		{ $AllArgs += @("/server1:$MyServerInstance", "/database1:$MyDatabase ") }
		else #Ah. we are creating a build script from an object-level source
		{ $AllArgs += @("/scripts1:$MyDatabasePath",'/Options:Default,iscn') }
		$AllArgs += @("/empty2", "/force",
			"/scriptfile:$MybuildScriptPath\$($MyDatabase)BuildScript$MyVersion.SQL")
		&$SQLCompare @AllArgs >>"$MyReportPath\$MyDatabase$MyVersionReport.txt"
		if ($?) { "Build Script successfully generated $SourceAndTarget" }
		else
		{
			#if there was an error of some sort
			if ($LASTEXITCODE -eq 63) { 'Database empty' }
			else
			{
				$SoFarSoGood = $false;
				$SQLCompareError = "SQL Compare had an error during generation of build script $SourceAndTarget! (code $LASTEXITCODE) - $(
					$ErrorMeanings."$lastexitcode")"
				Write-Error $SQLCompareError
			}
		}
	}
	
<# Now we can write the data out if there are any changes #>
	$AllArgs = @()
	if ($MyUserId -ne $NULL) { $AllArgs += "/username$($dbs):$MyUserId" }
	if ($MyPassword -ne $NULL) { $AllArgs += "/Password$($dbs):$MyPassword" }
	if ($MyScriptsPath -ne $null)
	{
		if (-not (Test-Path -PathType Container $MyScriptsPath))
		{
			# not there, so we create the report directory 
			$null = New-Item -ItemType Directory -Force -Path $MyScriptsPath;
		}
		
		$AllArgs += @("/scriptfile:$MyScriptsPath\$($MyDatabase)DataScript$MyVersion.SQL")
	}
	$AllArgs += @("/server$($dbs):$MyServerInstance", "/database$($dbs):$MyDatabase ",
		"/scripts$($scr):$MyDatabasePath", '/q', '/showWarnings', '/AbortOnWarnings:Medium',
		'/force', '/Include:Identical','/Options:Default,SkipFkChecks,DisableKeys,UseChecksumComparison')
	if ($IWantToSynchPlease) { $AllArgs += @('/synch') }
	If ($MyExportPath -ne $null)
	{
		if (-not (Test-Path -PathType Container $MyExportPath))
		{
			# not there so we create the json directory
			$null = New-Item -ItemType Directory -Force -Path $MyExportPath;
		}
		$AllArgs += "/export:$MyExportPath"
	}
	If ($SoFarSoGood -and $IWantTheDataPlease) #you can easily opt to not have the data.
	{
		&$SQLDataCompare @AllArgs  >>"$MyReportPath\$MyDatabase$MyVersionReport.txt"
		if ($?) { "updated Data successfully $SourceAndTarget" }
		else
		{
			if ($LASTEXITCODE -eq 63) { 'Databases were identical' }
			else
			{
				$SQLCompareError = "SQL Data Compare reported an error handling data $SourceAndTarget! (code $LASTEXITCODE) - $(
					$ErrorMeanings."$lastexitcode")"
				Write-Error $SQLCompareError
			}
			
		}
		if ($MyJSONExportPath -ne $null -and $MyExportPath -ne $null)
		{
			if (-not (Test-Path -PathType Container $MyJSONExportPath))
			{
				# not there so we create the json directory
				$null = New-Item -ItemType Directory -Force -Path $MyJSONExportPath;
			}
			dir $MyExportPath -File | Where { $_.basename -ne 'Results Summary' } | foreach{
				$file = $_;
				import-csv -path "$($file.FullName)" | ConvertTo-Json |
				Add-Content -Path "$MyJSONExportPath\$($file.BaseName).json" -Force
			}
		}
	}
} 

