$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
$localNugetRepo = "$solutionPath\LocalPackages\"
$localPrivateNugetRepo = "$solutionPath\LocalPrivatePackages\"
$nugetExe = "$solutionPath\nuget.exe"
$dnbuild = "$env:programfiles\dotnet\dotnet.exe"
