$path = (Split-Path $MyInvocation.MyCommand.Path)
. $path/PublishDockerPackage.ps1 

$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts\PublishScripts","")
Set-Location $solutionPath;

function Get-MicroServices() {
	return @(
        @{ publishDir = "DeviceDataStorage"; yamlFile = "DeviceDataStorageDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.Services.DeviceDataStorage"; tagName ="devicedatastorage" },
        @{ publishDir = "DeviceRepo"; yamlFile = "DeviceRepoDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.Services.DeviceRepo"; tagName ="devicerepo" },
        @{ publishDir = "NotificationPublisher"; yamlFile = "NotificationPublisherDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.Services.NotificationPublisher"; tagName ="notif-publisher" },
        @{ publishDir = "LogWriter"; yamlFile = "LogWriterDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.Services.LogWriter"; tagName ="logwriter" },        
        @{ publishDir = "SettingsService"; yamlFile = "SettingsServiceDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.Services.SettingsService"; tagName ="settings-service" }
        @{ publishDir = "UsageWriter"; yamlFile = "UsageWriterDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.Services.UsageWriter"; tagName ="usagewriter" },

        @{ publishDir = "ListenerModule"; yamlFile = "PEMListenerDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.Listener"; tagName ="pem-listener" },
        @{ publishDir = "PlannerModule"; yamlFile = "PEMPlannerDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.Planner"; tagName ="pem-planner" },
        @{ publishDir = "SentinelModule"; yamlFile = "PEMSentinelDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.Sentinel"; tagName ="pem-sentinel" },
        @{ publishDir = "InputTranslatorModule"; yamlFile = "PEMInputTranslatorDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.InputTranslator"; tagName ="pem-input-translator" },
        @{ publishDir = "DeviceWorkflowModule"; yamlFile = "PEMDeviceWorkflowDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.DeviceWorkflow"; tagName ="pem-device-workflow" },
        @{ publishDir = "OutputTranslatorModule"; yamlFile = "PEMOutputTranslatorDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.OutputTranslator"; tagName ="pem-output-translator" },
        @{ publishDir = "TransmitterModule"; yamlFile = "PEMTransmitterDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.Transmitter"; tagName ="pem-transmitter" },
        @{ publishDir = "DataStreamWriterModule"; yamlFile = "PEMDataStreamWriterDeployment.yaml"; projectFile = "LagoVista.IoT.Runtime.ModuleHost.DataStreamWriter"; tagName ="pem-data-stream-writer"; nuviotModule = "io.IoTEngine" ; removeAppSettings = $TRUE }

        @{ publishDir = "ConsoleRuntime"; projectFile = "LagoVista.IoT.Runtime.Console"; tagName ="full-runtime"; nuviotModule = "io.IoTEngine" ; removeAppSettings = $FALSE }
        @{ publishDir = "SimulatorNetwork"; projectFile = "LagoVista.IoT.Simulator.Runtime.Portal"; tagName ="simulator-network"; nuviotModule = "ss.SimulatorServices" ; removeAppSettings = $FALSE }

        @{ publishDir = "DocumentationSite"; projectFile = "NuvIot.WebDocs"; tagName ="support-site"; nuviotModule = "do.Documentation" ; removeAppSettings = $TRUE }
        @{ publishDir = "MasterControlProgram"; projectFile = "LagoVista.IoT.MCP.Host"; tagName ="mcps"; nuviotModule = "mc.MasterControlProgram" ; removeAppSettings = $FALSE }
    
    )
}

function Get-MicroServices() {
	return @(                
        @{ publishDir = "ConsoleRuntime"; projectFile = "LagoVista.IoT.Runtime.Console"; tagName ="full-runtime"; nuviotModule = "io.IoTEngine" ; removeAppSettings = $FALSE }
    )
}

$end = Get-Date
$start = Get-Date "5/17/2017"

$today = Get-Date
$today = $today.ToShortDateString()
$today = Get-Date $today

$major = 1
$minor = 6

$minutes = New-TimeSpan -Start $today -End $end
$revisionNumber = (New-TimeSpan -Start $start -End $end).Days
$buildNumber = ("{0:00}" -f [math]::Round($minutes.Hours)) + ("{0:00}" -f ([math]::Round($minutes.Minutes)))
$version = "$major.$minor.$revisionNumber.$buildNumber"
$version

$microServices = Get-MicroServices;
foreach($microService in $microServices) {
    Publish-DockerImage -publishDir $microService.publishDir `
                    -yamlFile $microService.yamlFile `
                    -projectFile $microService.projectFile `
                    -tagName $microService.tagName `
                    -nuviotModule $microService.nuviotModule `
                    -removeAppSettings $microService.removeAppSettings `
                    -version $version
}
