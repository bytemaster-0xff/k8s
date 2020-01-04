$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath

. ./BuildScripts/GetRepos.ps1
. ./BuildScripts/Utils.ps1
. ./BuildScripts/Versioning.ps1
. ./BuildScripts/Constants.ps1
. ./BuildScripts/Build.ps1
. ./BuildScripts/Nuget.ps1

$repos = Get-Repos;

foreach( $repo in $repos){
    $localPath = $repo.LocalPath
    $repoPath = "$solutionPath\$localPath"
    $repoPath
    
    Set-Location $repoPath

    $out = git pull  2>&1
    if ($?) {
        $out
    } else {       
        $out.Exception
    }

    Set-Location $solutionPath
}

Save-DefaultNugetVersionNumbers

$global:failedBuilds = 0
$global:failedRestores = 0
$global:failedPacks = 0

$global:successBuilds = 0
$global:successRestores = 0
$global:successPacks = 0

Remove-OldNuGetPackages

$startProcess = Get-Date

$version = Generate-VersionNumber -preRelease alpha -major 1 -minor 2
$version

Set-NugetVersionNumbers -versionNumber $version
Update-LagoVistaDependencies -version $version

$repos = Get-Repos;
foreach($repo in $repos) {
   if($repo.Build -eq $true) {
       Perform-Build -repo $repo -fullRestore $true;
       if($global:failedBuilds -gt 0 -or $global:failedRestores -gt 0 -or $global:failedPacks -gt 0){
           break
      }
   }
}

Update-APIXml

$endProcess = Get-Date 

$deltaBuild = New-TimeSpan -Start $startProcess -End $endProcess

Write-Host ""
Write-Host "=============================================="
Write-Host "Build completed in $([math]::Round($deltaBuild.TotalSeconds,1)) seconds to run"
Write-Host "Success " -ForegroundColor "green"
Write-Host "  Restores  : $global:successRestores" -foregroundcolor "green"
Write-Host "  Builds    : $global:successBuilds" -foregroundcolor "green"
Write-Host "  Packs     : $global:successPacks" -foregroundcolor "green"
Write-Host " "
Write-Host "Failed " -ForegroundColor "red"
Write-Host "  Restores  : $global:failedRestores" -foregroundcolor "red"
Write-Host "  Builds    : $global:failedBuilds" -foregroundcolor "red"
Write-Host "  Packs     : $global:failedPacks" -foregroundcolor "red"
Write-Host ""
Write-Host "=============================================="
Write-Host ""