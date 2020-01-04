$solutionPath = (Split-Path $MyInvocation.MyCommand.Path).Replace("\BuildScripts","");
Set-Location $solutionPath

. ./BuildScripts/GetRepos.ps1

function Remove-OldNuGetPackages() {
    New-Item -ItemType Directory -Force $localNugetRepo
    New-Item -ItemType Directory -Force $localPrivateNugetRepo
   
    $oldPublicChildren = gci $localNugetRepo *.nupkg
    foreach( $oldChild in $oldPublicChildren){
	    Remove-Item $oldChild.FullName 
    }

    $oldPrivateChildren = gci $localPrivateNugetRepo *.nupkg
    foreach( $oldChild in $oldPrivateChildren){
	   Remove-Item $oldChild.FullName 
    }
}

function Update-APIXml() {
    Copy-Item "$solutionPath\bi.Billing\src\LagoVista.IoT.Billing.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Billing.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\bi.Billing\src\LagoVista.IoT.Billing.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Billing.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\da.DeviceAdmin\src\LagoVista.IoT.DeviceAdmin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.DeviceAdmin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\da.DeviceAdmin\src\LagoVista.IoT.DeviceAdmin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.DeviceAdmin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\de.Deployments\src\LagoVista.IoT.Deployment.Admin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Deployment.Admin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\de.Deployments\src\LagoVista.IoT.Deployment.Admin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Deployment.Admin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\dg.DeviceManagement\src\LagoVista.IoT.DeviceManagement.Rest\bin\Release\netstandard2.0\LagoVista.IoT.DeviceManagement.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\dg.DeviceManagement\src\LagoVista.IoT.DeviceManagement.Rest\bin\Release\netstandard2.0\LagoVista.IoT.DeviceManagement.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\dm.DeviceMessagingAdmin\src\LagoVista.IoT.DeviceMessaging.Rest\bin\Release\netstandard2.0\LagoVista.IoT.DeviceMessaging.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\dm.DeviceMessagingAdmin\src\LagoVista.IoT.DeviceMessaging.Rest\bin\Release\netstandard2.0\LagoVista.IoT.DeviceMessaging.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"
    
    Copy-Item "$solutionPath\ge.GeoNavigation\src\LagoVista.IoT.GeoNavigation.Rest\bin\Release\netstandard2.0\LagoVista.IoT.GeoNavigation.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\ge.GeoNavigation\src\LagoVista.IoT.GeoNavigation.Rest\bin\Release\netstandard2.0\LagoVista.IoT.GeoNavigation.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\pm.PipelineManagement\src\LagoVista.IoT.Pipeline.Admin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Pipeline.Admin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\pm.PipelineManagement\src\LagoVista.IoT.Pipeline.Admin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Pipeline.Admin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\pr.ProjectManagement\src\LagoVista.IoT.ProjectManagement.Rest\bin\Release\netstandard2.0\LagoVista.IoT.ProjectManagement.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\pr.ProjectManagement\src\LagoVista.IoT.ProjectManagement.Rest\bin\Release\netstandard2.0\LagoVista.IoT.ProjectManagement.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\ss.SimulatorServices\src\LagoVista.IoT.Simulator.Admin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Simulator.Admin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\ss.SimulatorServices\src\LagoVista.IoT.Simulator.Admin.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Simulator.Admin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\ur.UserAdminRest\src\LagoVista.UserAdmin.Rest\bin\Release\netstandard2.0\LagoVista.UserAdmin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\ur.UserAdminRest\src\LagoVista.UserAdmin.Rest\bin\Release\netstandard2.0\LagoVista.UserAdmin.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\pr.ProjectManagement\src\LagoVista.IoT.ProjectManagement.Rest\bin\Release\netstandard2.0\LagoVista.IoT.ProjectManagement.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\pr.ProjectManagement\src\LagoVista.IoT.ProjectManagement.Rest\bin\Release\netstandard2.0\LagoVista.IoT.ProjectManagement.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\vm.ViewManager\src\LagoVista.UI.ViewManager.Rest\bin\Release\netstandard2.0\LagoVista.UI.ViewManager.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\vm.ViewManager\src\LagoVista.UI.ViewManager.Rest\bin\Release\netstandard2.0\LagoVista.UI.ViewManager.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"

    Copy-Item "$solutionPath\ve.Verifiers\src\LagoVista.IoT.Verifiers.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Verifiers.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.API\wwwroot\xmldocs"
    Copy-Item "$solutionPath\ve.Verifiers\src\LagoVista.IoT.Verifiers.Rest\bin\Release\netstandard2.0\LagoVista.IoT.Verifiers.Rest.xml" "$solutionPath\nu.NuvIoT\src\LagoVista.IoT.Web.Portal\wwwroot\xmldocs"
}

Update-APIXml