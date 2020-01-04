function Create-LocalNuget($repo) {
    if($repo.Private -eq $True)  {
        $nugetRepoPath = $localPrivateNugetRepo
    }
    else {
        $nugetRepoPath = $localNugetRepo
    }

    $path = $repo.LocalPath

    $children = gci "$solutionPath\$path" -recurse *.nuspec
    foreach( $child in $children) {
	    Write-Output $child.FullName        
	    & $nugetExe pack  -OutputDirectory $nugetRepoPath $child.FullName
        if($LASTEXITCODE -eq 0) {        
            Set-Variable -name "successPacks" -value ($successPacks + 1) -Scope Global
        }  
        else {
            Write-Host "$failure - Create Local Nuget $solutionPath" -ForegroundColor "red"
            Set-Variable -name "failedPacks" -value ($failedPacks + 1) -Scope Global
        }    
    }
}