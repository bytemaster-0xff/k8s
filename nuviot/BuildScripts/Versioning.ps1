function Generate-VersionNumber([string]$preRelease,[string]$major,[string]$minor,[string]$buildNumber) {
    $end = Get-Date
    $start = Get-Date "5/17/2017"

    $today = Get-Date
    $today = $today.ToShortDateString()
    $today = Get-Date $today

    if(!$major) {$major = $versionPart[0]}
    if(!$minor) {$minor = $versionPart[1]}
    $revisionNumber = New-TimeSpan -Start $start -End $end
    $minutes = New-TimeSpan -Start $today -End $end
	if(!$buildNumber) {$buildNumber = ("{0:00}" -f [math]::Round($minutes.Hours)) + ("{0:00}" -f ([math]::Round($minutes.Minutes)))}


    if($preRelease){
        return $major +"." + $minor + "." + $revisionNumber.Days + "-$preRelease$buildNumber"
        }
    else{
        return $major +"." + $minor + ".0"
    }
}

function Set-NugetVersionNumbers([string] $versionNumber) {
    $children = gci ./ -recurse *.nuspec 

    foreach( $child in $children){
        $nuspecFile = gi $child.fullName
        [xml] $content = Get-Content $nuspecFile

        $content.package.metadata.version = $versionNumber
	    $content.Save($child.FullName)
    }
}

function Save-DefaultNugetVersionNumbers() {
    $children = gci ./ -recurse *.nuspec 

    foreach( $child in $children){
        $nuspecFile = gi $child.fullName
        [xml] $content = Get-Content $nuspecFile
        $outVersion = $content.package.metadata.version
        $outFile = "$nuspecFile.txt"

        $outVersion | Out-File -FilePath $outFile 
    }

     $children = gci $solutionPath -recurse *.csproj 

    foreach( $child in $children){        
        $csprojFile = gi $child.fullName
        
        $versionOutputFile = "$csprojFile.bak"
        if(Test-Path $versionOutputFile){
            Remove-Item $versionOutputFile
        }
       
        [xml] $content = Get-Content $csprojFile

        foreach($projectReference in $content.Project.ItemGroup.PackageReference) {
            $referenceName = $projectReference.Include            

            if($referenceName -and $referenceName.StartsWith("LagoVista")) {
               $version = $projectReference.Version
               Add-Content  $versionOutputFile  "$referenceName=$version"
            }        
        }
    }
    
    $children = gci $solutionPath -recurse packages.config 

    foreach( $child in $children){        
        $packageFile = gi $child.fullName
        [xml] $content = Get-Content $packageFile
        
        $versionOutputFile = "$packageFile.bak"
       
        if(Test-Path $versionOutputFile){
            Remove-Item $versionOutputFile
        }

        foreach($package in $content.packages.package) {
            $packageName = $package.id     
          
            if($packageName -and $packageName.StartsWith("LagoVista")) {
                $version = $package.version
                Add-Content  $versionOutputFile  "$referenceName=$version"
            }        
        }
    }
}

function Reset-DefaultNugetVersionNumbers() {
    $children = gci ./ -recurse *.nuspec 

    foreach( $child in $children){
        $nuspecFile = gi $child.fullName
        [xml] $content = Get-Content $nuspecFile
        $outFile = "$nuspecFile.txt"

        $previousVersion = Get-Content $outFile
        $content.package.metadata.version = [string]$previousVersion
    	$content.Save($child.FullName)
     }

     $children = gci $solutionPath -recurse *.csproj 


    foreach( $child in $children){        
        $csprojFile = gi $child.fullName
        
        $versionOutputFile = "$csprojFile.bak"
        if(Test-Path $versionOutputFile){
            [xml] $content = Get-Content $csprojFile

            $versionHash = @{}

            $reader = [System.IO.File]::OpenText($versionOutputFile)
            while($null -ne ($line = $reader.ReadLine())) {
                $versionHash[$line.split("=")[0]] = $line.split("=")[1]
            }
            $reader.Close();

            foreach($projectReference in $content.Project.ItemGroup.PackageReference) {
                $referenceName = $projectReference.Include            

                if($referenceName -and $referenceName.StartsWith("LagoVista")) {
                    $projectReference.Version = $versionHash[$referenceName]
                }        
            }

            $content.save($csprojFile)
        }
    }
}


function Cleanup-DefaultNugetVersionNumbers {
    $children = gci ./ -recurse *.nuspec 

    foreach( $child in $children){
        $nuspecFile = gi $child.fullName
        [xml] $content = Get-Content $nuspecFile
        $outVersion = $content.package.metadata.version
        $versionOutFile = "$nuspecFile.txt"
        if(Test-Path $versionOutFile){
            Remove-Item $versionOutFile
        }
    }

     $children = gci $solutionPath -recurse *.csproj 

    foreach( $child in $children){        
        $csprojFile = gi $child.fullName
        
        $versionOutputFile = "$csprojFile.bak"
        if(Test-Path $versionOutputFile){
            Remove-Item $versionOutputFile
        }
    }
    
    $children = gci $solutionPath -recurse packages.config 

    foreach( $child in $children){        
        $packageFile = gi $child.fullName
        [xml] $content = Get-Content $packageFile
        
        $versionOutputFile = "$packageFile.bak"
       
        if(Test-Path $versionOutputFile){
            Remove-Item $versionOutputFile
        }
    }
}

function Set-AssemblyVersionNubmers([string] $versionNumber) {
    $children = gci ./ -recurse *.nuspec 

    foreach( $child in $children){
        $nuspecFile = gi $child.fullName
        [xml] $content = Get-Content $nuspecFile

        $content.Project.ProjectGroup.AssemblyVersion = $versionNumber
	    $content.Project.ProjectGroup.FileVersion = $versionNumber
	    $content.Project.ProjectGroup.AssemblyVersion = $versionNumber
	    $content.Save($child.FullName)
    }
}

function Update-LagoVistaDependencies([string] $version) {
    $children = gci $solutionPath -recurse *.csproj 

    foreach( $child in $children){        
        $csprojFile = gi $child.fullName
        [xml] $content = Get-Content $csprojFile

        foreach($projectReference in $content.Project.ItemGroup.PackageReference) {
            $referenceName = $projectReference.Include            

            if($referenceName -and $referenceName.StartsWith("LagoVista") -and -not $referenceName.StartsWith("LagoVista.Client") -and -not $referenceName.StartsWith("LagoVista.XPlat")) {
                $projectReference.Version = $version
            }        
        }

        $content.Save($child.FullName)        
    }

     $children = gci $solutionPath -recurse packages.config 

    foreach( $child in $children){        
        $packageFile = gi $child.fullName
        [xml] $content = Get-Content $packageFile

        foreach($package in $content.packages.package) {
            $packageName = $package.id     

            if($packageName -and $packageName.StartsWith("LagoVista") -and -not $referenceName.StartsWith("LagoVista.Client") -and -not $referenceName.StartsWith("LagoVista.XPlat")) {
                $package.version = $version
            }        
        }

        $content.Save($child.FullName)        
    }
}
