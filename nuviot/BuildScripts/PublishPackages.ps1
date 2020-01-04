$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath


. ./BuildScripts/Constants.ps1

$remotePrivateRepoUri = "https://slsys.pkgs.visualstudio.com/_packaging/lagovista/nuget/v2"
$global:failedPublish = 0
$global:successPublish = 0

$global:failedPrivatePublish = 0
$global:successPrivatePublish = 0

$nugetExe = "$solutionPath\nuget.exe"



#Add Keys: NUGETAPIKEY (from nuget.org) and VSTSLGVPACKAGEKEY from VSTS Packages for LagoVista
#run this to grant permission
& "$solutionPath\nuget.exe" sources add -name LagoVistaPrivateRepo -source $remotePrivateRepoUri -username dontcare -password $env:VSTSLGVPACKAGEKEY
& $nugetExe sources Add -Name "lagovista" -Source "https://slsys.pkgs.visualstudio.com/_packaging/lagovista/nuget/v3/index.json"

function Publish-Remote() {
    $children = gci $localNugetRepo  *.nupkg

    foreach( $child in $children){
	    Write-Output "Publishing Output $child.fullName" 
        & $nugetExe push $child.fullName -Source https://www.nuget.org/api/v2/package -ApiKey $env:NUGETAPIKEY

        if($LASTEXITCODE -eq 0) {
           Set-Variable -name "successPublish" -value ($successPublish + 1) -Scope Global
        }  
        else {
            Write-Host "$failure - Publish Nuget $solutionPath" -ForegroundColor "red"
            Set-Variable -name "failedPublish" -value ($failedPublish + 1) -Scope Global
        }    
    }
}


function Publish-PrivateRemote() {
    $children = gci $localNugetRepoPrivate  *.nupkg

    foreach( $child in $children){
	    Write-Output "Publishing Output $child.fullName" 

        & $nugetExe push -Source "lagovista" -ApiKey VSTS $child.FullName

        if($LASTEXITCODE -eq 0) {
           Set-Variable -name "successPrivatePublish" -value ($successPrivatePublish + 1) -Scope Global
        }  
        else {
            Write-Host "$failure - Publish Nuget $solutionPath" -ForegroundColor "red"
           Set-Variable -name "failedPrivatePublish" -value ($failedPrivatePublish + 1) -Scope Global
        }    
    }
}

$startProcess = Get-Date
Publish-Remote
Publish-PrivateRemote

$endProcess = Get-Date

$deltaBuild = New-TimeSpan -Start $startProcess -End $endProcess

Write-Host ""
Write-Host "=============================================="
Write-Host "Publish completed in $([math]::Round($deltaBuild.TotalSeconds,1)) seconds to run"
Write-Host "Success " -ForegroundColor "green"
Write-Host "  Public    : $global:successPublish" -foregroundcolor "green"
Write-Host "  Private   : $global:successPrivatePublish" -foregroundcolor "green"
Write-Host ""
Write-Host "Failures " -ForegroundColor "red"
Write-Host "  Public    : $global:failedPublish" -foregroundcolor "red"
Write-Host "  Private   : $global:failedPrivatePublish" -foregroundcolor "red"
Write-Host "=============================================="
Write-Host ""