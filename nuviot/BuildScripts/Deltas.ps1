$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath

$solutionPath

. ./BuildScripts/GetRepos.ps1
. ./BuildScripts/Utils.ps1
. ./BuildScripts/Versioning.ps1
. ./BuildScripts/Constants.ps1
. ./BuildScripts/Build.ps1
. ./BuildScripts/Nuget.ps1

Get-DirtyRepos
