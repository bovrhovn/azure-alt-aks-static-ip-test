<#

.SYNOPSIS

Deploy resources to Azure from a Bicep template and after that compile containers inside the folder
and deploy them to 

.DESCRIPTION

Deploy resources to Azure from a Bicep template using New-AzResourceGroupDeployment
 
.EXAMPLE

PS > Create-Resources.ps1 -ResourceGroupName "rg-alt" -TemplateFile "main.bicep" -ParametersFile "main.parameters.json"

Deploy resources to Azure from a Bicep template in resource group rg-alt with main.bicep and main.parameters.json

.LINK

https://github.com/bovrhovn/azure-alt-aks-static-ip-test
 
#>
param(
    [Parameter(Mandatory = $true)]
    $ResourceGroupName = "rg-alt-aks",
    [Parameter(Mandatory = $true)]
    $TemplateFile = "main.bicep",
    [Parameter(Mandatory = $true)]
    $ParametersFile = "main.parameters.json",        
    [Parameter(Mandatory = $false)]
    [switch]$OpenLog
)
$logPath = "$HOME/Downloads/create-resources.log"
Start-Transcript -Path $logPath -Force
Write-Host "Starting deployment to Azure..."
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -TemplateParameterFile $parametersFile
Write-Host "Resources created, go and deploy containers and run yaml files to create resources in AKS."
Stop-Transcript
#read it in notepad
if ($OpenLog)
{
    Write-Information "Opening log file $logPath"
    Start-Process "notepad" -ArgumentList $logPath
}
