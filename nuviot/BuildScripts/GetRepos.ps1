

function Get-Repos() {
	return @(
		@{ProjectName = "Core"; LocalPath="co.Core"; Repo = "https://github.com/lagovista/core"; Solution="Core.sln"; Private=$False;Build=$True },
		@{ProjectName = "Logging Support"; LocalPath="lo.Logging"; Repo = "https://github.com/lagovista/logging"; Solution="Logging.sln"; Private=$False;Build=$True }, 
		@{ProjectName = "Cloud Storage"; LocalPath="cs.CloudStorage"; Repo = "https://github.com/lagovista/cloudstorage"; Solution="CloudStorage.sln"; Private=$False;Build=$True },
		@{ProjectName = "User Admin"; LocalPath="ua.UserAdmin"; Repo = "https://github.com/lagovista/useradmin"; Solution="UserAdmin.sln"; Private=$False;Build=$True },
		@{ProjectName = "Web Common"; LocalPath="wc.WebCommon"; Repo = "https://github.com/lagovista/webcommon"; Solution="WebCommon.sln"; Private=$False;Build=$True },
		@{ProjectName = "Device Admin"; LocalPath="da.DeviceAdmin"; Repo = "https://github.com/lagovista/deviceadmin"; Solution="DeviceAdmin.sln"; Private=$False;Build=$True },
		@{ProjectName = "Device Messaging Admin"; LocalPath="dm.DeviceMessagingAdmin"; Repo = "https://github.com/lagovista/DeviceMessagingAdmin"; Solution="DeviceMessagingAdmin.sln"; Private=$False; Build=$True },
		@{ProjectName = "Pipeline Management"; LocalPath="pm.PipelineManagement"; Repo = "https://github.com/lagovista/PipelineManagement"; Solution="PipelineManagement.sln"; Private=$False; Build=$True },
		@{ProjectName = "Device Management"; LocalPath="dg.DeviceManagement"; Repo = "https://github.com/lagovista/DeviceManagement"; Solution="DeviceManagement.sln"; Private=$False; Build=$True },
		@{ProjectName = "Simulator Services"; LocalPath="ss.SimulatorServices"; Repo = "https://github.com/lagovista/SimulatorServices"; Solution="SimulatorServices.sln"; Private=$False; Build=$True },
		@{ProjectName = "Deployment Admin"; LocalPath="de.Deployments"; Repo = "https://github.com/lagovista/Deployments"; Solution="Deployments.sln"; Private=$False; Build=$True },
        @{ProjectName = "Runtime Core"; LocalPath="ru.Runtime"; Repo = "https://github.com/lagovista/Runtime"; Solution="Runtime.sln"; Private=$False; Build=$True },
        @{ProjectName = "Verifiers"; LocalPath="ve.Verifiers"; Repo = "https://github.com/lagovista/Verifiers"; Solution="Verifiers.sln"; Private=$False; Build=$True },
		@{ProjectName = "User Admin REST"; LocalPath="ur.UserAdminRest"; Repo = "https://github.com/lagovista/UserAdminRest"; Solution="UserAdminRest.sln"; Private=$False; Build=$True },
        @{ProjectName = "Billing"; LocalPath="bi.Billing"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/NuvIotBilling"; Solution="Billing.sln"; Private=$True; Build=$true }
	 	@{ProjectName = "Project Management"; LocalPath="pr.ProjectManagement"; Repo = "https://slsys.visualstudio.com/DefaultCollection/LagoVista/_git/ProjectManagement"; Solution="ProjectManagement.sln"; Private=$True; Build=$True },
        @{ProjectName = "Geo Navigation"; LocalPath="ge.GeoNavigation"; Repo = "https://slsys.visualstudio.com/DefaultCollection/LagoVista/_git/GeoNavigation"; Solution="GeoNavigation.sln"; Private=$True; Build=$True },
        @{ProjectName = "Starter Kit"; LocalPath="sk.StarterKit"; Repo = "https://github.com/lagovista/StarterKit"; Solution="StarterKit.sln"; Private=$False;Build=$True },        		
        @{ProjectName = "View Manager"; LocalPath="vm.ViewManager"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/ViewManager"; Solution="ViewManager.sln"; Private=$True;Build=$True },
        @{ProjectName = "Application Support"; LocalPath="as.NuvIoTAppSupport"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/NuvIoTAppSupport"; Solution="AppSupport.sln"; Private=$True; Build=$True },
		@{ProjectName = "IoT Engine"; LocalPath="io.IoTEngine"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/IoTEngine"; Solution="Engine.sln"; Private=$True; Build=$True; Restore=$True  },
        @{ProjectName = "NuvIoT Web/API"; LocalPath="nu.NuvIot"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/Nuviot"; Solution="Web.sln"; Private=$True; Build=$True; Restore=$True },
	    @{ProjectName = "Notifiations Server"; LocalPath="no.Notifications"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/NotificationServer"; Solution="NotificationServer.sln"; Private=$True; Build=$True; Restore=$True },
	 	@{ProjectName = "NuvIoT Integration Tests"; LocalPath="ni.IntegrationTests"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/Nuviot.IntegrationTests"; Solution="IntegrationTests.sln"; Private=$True; Build=$false }
	 	@{ProjectName = "Master Control Program"; LocalPath="mc.MasterControlProgram"; Repo = "https://slsys.visualstudio.com/LagoVista/_git/MCP"; Solution="mcp.sln"; Private=$True; Build=$true; Restore=$True  }
	)
}

function Get-DirtyRepos(){
    $allRepos = Get-Repos
    foreach( $repo in $repos){
        $localPath = $repo.LocalPath
        $repoPath = "$solutionPath\$localPath"
    
        Set-Location $repoPath
        $changedFiles = & git diff --name-only

        
        Set-Location $solutionPath
    }  
}
