$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath

. ./BuildScripts/GetRepos.ps1
. ./BuildScripts/Utils.ps1
. ./BuildScripts/Versioning.ps1
. ./BuildScripts/Constants.ps1
. ./BuildScripts/Build.ps1
. ./BuildScripts/Nuget.ps1


$confirmation = Read-Host "Are you Sure You Want To Continue?  This will remove all existing Repositories and changes [Y] to continue"
if ($confirmation -eq 'Y') {
    $repos = Get-Repos;

    Remove-OldNuGetPackages

    foreach( $repo in $repos){
        if(Test-Path $repo.LocalPath){
            Remove-Item -Recurse -Force $repo.LocalPath
        }
    }

    foreach( $repo in $repos){
        $out = git clone $repo.Repo $repo.LocalPath  2>&1
        if ($?) {
            $out
        } else {
       
            $out.Exception
        }
    }

    Save-DefaultNugetVersionNumbers
}