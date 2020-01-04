$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath

. ./BuildScripts/GetRepos.ps1
. ./BuildScripts/Utils.ps1
. ./BuildScripts/Versioning.ps1
. ./BuildScripts/Constants.ps1
. ./BuildScripts/Build.ps1
. ./BuildScripts/Nuget.ps1

Reset-DefaultNugetVersionNumbers
Cleanup-DefaultNugetVersionNumbers

$repos = Get-Repos;

foreach( $repo in $repos){
    $localPath = $repo.LocalPath
    $repoPath = "$solutionPath\$localPath"
    $repoPath
    
    Set-Location $repoPath

        $out.Exception
    $out = git add .  2>&1
    if ($?) {
        $out
    } else {       
    }

    $out = git commit -m "Add new simulator message type" 2>&1
    if ($?) {
        $out
    } else {
       
        $out.Exception
    }

    $out = git push 2>&1
    if ($?) {
        $out
    } else {
       
        $out.Exception
    }

    Set-Location $solutionPath
}

Save-DefaultNugetVersionNumbers