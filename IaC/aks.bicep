@description('Name of the AKS cluster')
param aksName string

@description('Location for the AKS cluster')
param location string = resourceGroup().location

@description('DNS prefix for the AKS cluster')
param dnsPrefix string

@description('Number of nodes in the agent pool')
param agentCount int = 3

@description('VM size for the agent nodes')
param agentVMSize string = 'Standard_DS2_v2'

@description('Subnet ID for the AKS node pool')
param vnetSubnetId string

@description('Name of the Azure Container Registry')
param acrName string

// Existing ACR
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

// AKS Cluster with SystemAssigned identity (simplest for ACR integration)
resource aks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vnetSubnetID: vnetSubnetId
        mode: 'System'
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
    }
  }
}

// Assign AcrPull role to the kubelet identity (SystemAssigned identity of AKS)
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, aks.id, 'acrpull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d'
    ) // AcrPull
    principalId: aks.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output aksClusterName string = aks.name
output aksPrincipalId string = aks.identity.principalId