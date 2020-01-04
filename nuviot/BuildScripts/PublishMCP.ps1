$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
$solutionPath
Set-Location $solutionPath

$publishDir = "./PublishedMCPs"
if(Test-Path $publishDir){
    Remove-Item -Recurse -Force $publishDir
}

if(Test-Path $publishDir) {
   Throw "Could Not Remove Old Directory"
}

$gitrepo = "https://github.com/bytemaster-0xff/PublishedMCPs" 

$out = git clone $gitrepo $publishDir
if ($?) {
    Write-Host -ForegroundColor green "Got Latest"
} else {       
    Write-Host -ForegroundColor Red "Got Latest $out"
}

if(Test-Path "$solutionPath\$publishDir\publish"){
    Remove-Item -Recurse -Force "$solutionPath\$publishDir\publish"
}

dotnet publish  ./mc.MasterControlProgram/src/LagoVista.IoT.MCP.Host/LagoVista.IoT.MCP.Host.csproj -c Release -o "$solutionPath\$publishDir\publish"

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

$tag = "slsys.mcp.$version"
$tagMsg = """Master Control Program Version $version"""

$jsonDate = (get-date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

$versionContents = "{""version"":""$version"",""buildDate"":""$jsonDate""}"
$versionContents

#Login-AzureRmAccount

#$testConnections = Get-AzureKeyVaultSecret -VaultName 'Nuviot' -Name 'mcp-test'
#$testConnections.SecretValueText | Out-File "$solutionPath\$publishDir\publish\appsettings.Test.json" 

#$prodConnections = Get-AzureKeyVaultSecret -VaultName 'Nuviot' -Name 'mcp-prod'
#$prodConnections.SecretValueText | Out-File "$solutionPath\$publishDir\publish\appsettings.Production.json" 

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