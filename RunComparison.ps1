<# first, find out where we were executed from each environment has a different way
of doing it. It all depends how you execute it #>
try {
$executablepath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) }
catch{$executablepath -eq ''}
if ($executablepath -eq '')
{
	$executablepath = "$(If ($psISE)
		{ Split-Path -Path $psISE.CurrentFile.FullPath }
		Else { $global:PSScriptRoot })"
}
& "$executablepath\Run-DatabaseScriptComparison.ps1"
#create the scripts folder if necessary, otherwise update it. synch both the data and the metadata
Run-DatabaseScriptComparison -MyServerInstance 'MySQLServer' -UserName JoeBloggs -Verbose -MyDatabase 'PubsTest' -SourceType 'database' -SourceFolder 'PathToMyDirectory'
#synch both the data and the metadata from the script folder to AnotherSQLServer.Pubsone, create build scripts and create a scripts directory for them
Run-DatabaseScriptComparison -MyServerInstance 'AnotherSQLServer' -UserName JoeBloggs -Verbose -MyDatabase 'PubsOne' -SourceType 'source' -MyScripts 'PubsTest'  -SourceFolder 'PathToMyDirectory'
#synch both the data and the metadata from the script folder to AnotherSQLServer.PubsTwo, create build scripts and create a scripts directory for them
Run-DatabaseScriptComparison - -MyServerInstance 'AnotherSQLServer' -UserName JoeBloggs -Verbose -MyDatabase 'PubsTwo' -SourceType 'source' -MyScripts 'PubsTest'  -SourceFolder 'PathToMyDirectory'