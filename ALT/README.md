# Deploying solution to Azure Kubernetes Service (AKS)

## Prerequisites

Before you begin, ensure you have the following installed:
- [.NET SDK 9.0](https://dotnet.microsoft.com/download)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
- [Docker](https://docs.docker.com/get-docker/)
- [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

## Compiling the Code

You can compile the solution using the .NET CLI or the provided PowerShell script:

```powershell
# From the ALT directory
cd ALT
# Using .NET CLI
dotnet build ALT.sln

# Or use the provided script
../scripts/Compile-Containers.ps1
```

## Setting Up Environment Variables

Use the script in the scripts/ folder to set up environment variables:

```powershell
./scripts/Set-EnvVariables.ps1
```

## Deploying Infrastructure (IaC)

The IaC/ folder contains Bicep files for deploying Azure resources. You can use the provided scripts to automate deployment:

```powershell
# Install Azure CLI and Bicep if needed
./scripts/Install-AZCLI.ps1
./scripts/Install-Bicep.ps1

# Create resources
./scripts/Create-Resources.ps1
```

Alternatively, you can deploy manually using Azure CLI:

```powershell
az deployment sub create --location <location> --template-file ./IaC/main.bicep --parameters ./IaC/main.parameters.json
```

## Building and Pushing Containers

Build and push your containers to Azure Container Registry (ACR) as defined in the containers/ folder. Use Docker commands or scripts as needed.

## Deploying to AKS

After infrastructure is deployed and containers are available in ACR, use the manifests in the yaml/ folder to deploy to AKS:

```powershell
# Apply manifests in order
kubectl apply -f ./yaml/01-namespace-creation.yaml
kubectl apply -f ./yaml/02-yarp-secrets.yaml
kubectl apply -f ./yaml/03-yarp-deployment.yaml
kubectl apply -f ./yaml/04-api-deployment.yaml
kubectl apply -f ./yaml/05-network-policy.yaml
```

## Additional Notes
- Review and update configuration files in ALT.Api/appsettings.json and ALT.Yarp/appsettings.json as needed.
- For troubleshooting, check logs and resource status in Azure Portal and with kubectl.
