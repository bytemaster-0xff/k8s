# Load YAML Module : https://www.red-gate.com/simple-talk/blogs/psyaml-powershell-yaml/

function Publish-DockerImage($publishDir, $yamlFile, $projectFile, $tagName, $version, $nuviotModule = 'io.IoTEngine', $removeAppSettings = $TRUE, $platform = 'x86' ) {
    $publishDir = "$solutionPath\DockerPublish\$publishDir"

    $nuviotModule

    if(Test-Path $publishDir){
        Remove-Item -Recurse -Force $publishDir
    }

    $tag = "slsys.$tagName.$version"
    $tag

    $image = "nuviot/$tagName`:v$version"
    $image

    if(-not [string]::IsNullOrEmpty($yamlFile)) {
        if(Test-Path "$solutionPath\k8s"){
            Remove-Item -Recurse -Force "$solutionPath\k8s"
        }

        "----- CLONING K8 MANIFEST FILES -------"
        git clone https://github.com/LagoVista/k8s $solutionPath\k8s 2>$1     
        "OUT FROM CLONE2 $?"
        Write-Host -ForegroundColor green "  >> Cloned K8's Manifest into $solutionPath\k8s"

        if(Test-Path "$publishDir\publish"){
            Remove-Item -Recurse -Force "$publishDir\publish"
        }   


        $commitMessage = "Update Image - $image"

        "--------------------------------------------------------"    

        $yaml = Get-Content $solutionPath\k8s\$yamlFile
        $yaml = $yaml -replace "nuviot\/$tagName`:v[\d\.]+",$image   

        Set-Content $solutionPath\k8s\$yamlFile $yaml

        $deploymentUpdate = Get-Content $solutionPath\k8s\DeploymentUpdates.txt

        $deploymentUpdate = $deploymentUpdate -replace "nuviot\/$tagName`:v[\d\.]+",$image   
        Set-Content $solutionPath\k8s\DeploymentUpdates.txt $deploymentUpdate
  
        Set-Location $solutionPath\k8s

        
        "--------------------- DONE WRITING K8 FILES ------------"

        "$solutionPath\k8s"

        git add -f .
        $out = git commit -m $commitMessage
        if ($?) {
            Write-Host -ForegroundColor green "Committed: $out"
        } else {       
            Write-Host -ForegroundColor Red "Tagged: Err $out"
        }

        $out = git push -q
        if ($?) {
            Write-Host -ForegroundColor green "Pushed: $out"
        } else {       
            Write-Host -ForegroundColor Green "Push Err $out"
        }    
        "--------------------------------------------------------"
    }
    else{
        "Not procesing K8S Files"
    }
    
    "--------------------- BUILDING APP ---------------------"
    Set-Location $solutionPath

    dotnet publish  $solutionPath\$nuviotModule\src\$projectFile\$projectFile.csproj -c Release -o "$publishDir\publish" 

    if($removeAppSettings) {
        del "$publishDir\publish\appsettings*.*"
    }

    cp  $solutionPath\$nuviotModule\src\$projectFile\Dockerfile $publishDir\Dockerfile

    "--------------------------------------------------------"
    "----- SETTING TO OUTPUT DIR -------> $publishDir"

    Set-Location "$publishDir"    
    
    $jsonDate = (get-date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    
    $versionContents = "{""version"":""$version"",""buildDate"":""$jsonDate""}"    
    $versionContents
    $versionContents | Out-File "$publishDir\publish\version.json" 

    "Building Image $image"

    docker build -t $image .
    docker push $image

    if(-not [string]::IsNullOrEmpty($yamlFile)) {
        kubectl set image deployment.v1.apps/$tagName-deployment $tagName=$image --record
    }
}