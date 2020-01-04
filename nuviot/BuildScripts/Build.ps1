function Perform-Build ( $repo, $fullRestore = $false, $config = "release") {
    $path = $repo.LocalPath;
    $solution = $repo.Solution;
    $projectName = $repo.ProjectName

    $buildStart = Get-Date

    $slnPath = "$solutionPath\$path\$solution"

    Write-Host ""
    Write-Host "========================================================================================"
    
    #dotnet restore "$slnPath" --configfile "$solutionPath\..\Nuget.config"
    dotnet restore "$slnPath" --configfile "$solutionPath\Nuget.config"
    & $nugetExe restore "$slnPath" -configfile "$solutionPath\Nuget.config"
    
    $endRestore = Get-Date 
    $deltaRestore = New-TimeSpan -Start $buildStart -End $endRestore

    Write-Host "---- Restore of $projectName Completed in $([math]::Round($deltaRestore.TotalSeconds,1)) seconds to run ---- " -foregroundcolor "green"
    

    if($LASTEXITCODE -eq 0 -or $True) {
        Set-Variable -name "successRestores" -value ($successRestores + 1) -Scope Global

        & $dnbuild "build" $slnPath -c $config 

        if($LASTEXITCODE -eq 0) {
            Create-LocalNuget -repo $repo
            Set-Variable -name successBuilds -value ($successBuilds + 1) -Scope Global
        }  
        else {
            Write-Host "$failure - Building $path" -ForegroundColor "red"
            Set-Variable -name failedBuilds -value ($failedBuilds + 1) -Scope Global
        }    

    }  
    else {
        Write-Host "$failure - Restoring $path" -ForegroundColor "red"
        Set-Variable -name failedRestores -value ($failedRestores + 1) -Scope Global
    }    


    $endBuild = Get-Date 
    $deltaBuild = New-TimeSpan -Start $buildStart -End $endBuild

    Write-Host "---- Build of $projectName Completed in $([math]::Round($deltaBuild.TotalSeconds,1)) seconds to run ---- " -foregroundcolor "green"
}