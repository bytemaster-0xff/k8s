$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
$solutionPath
Set-Location $solutionPath

$publishDir = "./SharedHostPublish"
if(Test-Path $publishDir){
    Remove-Item -Recurse -Force $publishDir
}

$out = git clone https://github.com/bytemaster-0xff/PublishedSharedHosts $publishDir 2>$1 
if ($?) {
    Write-Host -ForegroundColor green "Got Latest"
} else {       
    Write-Host -ForegroundColor Red "Got Latest $out"
}

if(Test-Path "$solutionPath\$publishDir\publish"){
    Remove-Item -Recurse -Force "$solutionPath\$publishDir\publish"
}


dotnet publish  ./io.IoTEngine/src/LagoVista.IoT.Runtime.Shared.Host/LagoVista.IoT.Runtime.Shared.Host.csproj -c Release -o "$solutionPath\$publishDir\publish"

$end = Get-Date
$start = Get-Date "5/17/2017"

$today = Get-Date
$today = $today.ToShortDateString()
$today = Get-Date $today

$major = 1
$minor = 2

$minutes = New-TimeSpan -Start $today -End $end
$revisionNumber = (New-TimeSpan -Start $start -End $end).Days
$buildNumber = ("{0:00}" -f [math]::Round($minutes.Hours)) + ("{0:00}" -f ([math]::Round($minutes.Minutes)))
$version = "$major.$minor.$revisionNumber.$buildNumber"
$version

$commitMessage = "Build - $version"
$commitMessage

Set-Location "$solutionPath/$publishDir"
Get-Location 

$tag = "slsys.sharedhost.$version"
$tagMsg = """Shared Host Version $version"""

$jsonDate = (get-date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

$versionContents = "{""version"":""$version"",""buildDate"":""$jsonDate""}"
$versionContents

$secret = Get-AzureKeyVaultSecret -VaultName 'Nuviot' -Name 'devconnections'

$secret.SecretValueText | Out-File "$solutionPath\$publishDir\publish\appsettings.json" 
$versionContents | Out-File "$solutionPath\$publishDir\publish\version.json" 

git add -f .

$out = git commit -m $commitMessage 2>&1
if ($?) {
    Write-Host -ForegroundColor green "Committed: $out"
} else {       
    Write-Host -ForegroundColor Red "Tagged: Err $out"
}

$out = git tag -a $tag -m $tagMsg 2>&1
if ($?) {
    Write-Host -ForegroundColor green "Tagged: $out"
} else {       
    Write-Host -ForegroundColor Red "Tagged: Err $out"
}

$out = git push --tags 2>&1
if ($?) {
    Write-Host -ForegroundColor green "Pushed: $out"
} else {       
    Write-Host -ForegroundColor Red "Push Err $out"
}