Param([string]$module = "lo", [string] $destModule= "io"  )

$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath

. ./BuildScripts/GetRepos.ps1
. ./BuildScripts/Utils.ps1
. ./BuildScripts/Versioning.ps1
. ./BuildScripts/Constants.ps1
. ./BuildScripts/Build.ps1
. ./BuildScripts/Nuget.ps1

$global:failedBuilds = 0
$global:failedRestores = 0
$global:failedPacks = 0

$global:successBuilds = 0
$global:successRestores = 0
$global:successPacks = 0
$global:updatedNugetPackages = New-Object System.Collections.ArrayList;

$repos = Get-Repos;

$startProcess = Get-Date

$version = Generate-VersionNumber -preRelease alpha -major 1 -minor 2
Write-Host $version

function Set-SingleNugetNubmerForSingleProject([string] $versionNumber, [string] $projectPath) {
    $nugetPath = "$solutionPath\$projectPath"
    $children = gci $nugetPath -recurse  *.nuspec 

    foreach( $child in $children){
        $nuspecFile = gi $child.fullName
        [xml] $content = Get-Content $nuspecFile
        $global:updatedNugetPackages.Add($content.package.metadata.id);
        $content.package.metadata.version = $versionNumber
	    $content.Save($child.FullName)
    }
}

function Update-LagoVistaDependenciesForSingleProject([string] $versionNumber, [string] $projectPath) {
    $projectsParentPath = "$solutionPath\$projectPath"
    $csProjectChildren = gci "$projectsParentPath" -recurse *.csproj 
    $packageChildren = gci $projectsParentPath -recurse packages.config    

    foreach( $child in $csProjectChildren){        
        $csprojFile = gi $child.fullName
        [xml] $content = Get-Content $csprojFile

        foreach($projectReference in $content.Project.ItemGroup.PackageReference) {            
            $referenceName = $projectReference.Include            

            if($referenceName -and $referenceName.StartsWith("LagoVista")) {
                if($global:updatedNugetPackages.Contains($referenceName)){
                    Write-Host "Updating Reference $referenceName to " $versionNumber
                    $projectReference.Version = $versionNumber
                }
            }        
        }

        $content.Save($child.FullName)        
    }     

    foreach( $child in $packageChildren){        
        $packageFile = gi $child.fullName
        [xml] $content = Get-Content $packageFile

        foreach($package in $content.packages.package) {
            $packageName = $package.id     

            if($packageName -and $packageName.StartsWith("LagoVista")) {
                if($global:updatedNugetPackages.Contains($packageName)){
                    Write-Host "Updating Reference $packageName to " $versionNumber
                    $projectReference.Version = $versionNumber
                }

                $package.version = $version
            }        
        }

        $content.Save($child.FullName)        
    }
}

# Step One Build Dependency 
foreach($repo in $repos) {
   if($repo.LocalPath.StartsWith($module) -eq $true) {
       Set-SingleNugetNubmerForSingleProject -versionNumber $version -projectPath $repo.LocalPath
       Write-Host "Building Dependency " $repo.LocalPath
       Perform-Build -repo $repo;
       if($global:failedBuilds -gt 0 -or $global:failedRestores -gt 0 -or $global:failedPacks -gt 0){
            break
      }
   }
}


# Step Two Set the versions and build the target proejct 
foreach($repo in $repos) {
   if($repo.LocalPath.StartsWith($destModule) -eq $true) {
       Update-LagoVistaDependenciesForSingleProject -versionNumber $version -projectPath $repo.LocalPath
       Write-Host "Building Final Project" $repo.LocalPath
       Perform-Build -repo $repo;
       if($global:failedBuilds -gt 0 -or $global:failedRestores -gt 0 -or $global:failedPacks -gt 0){
            break
      }
   }
}

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