param vmssName string
param location string
param subnetId string
param instanceCount int = 2
param adminUsername string
@secure()
param adminPassword string
param acrName string
param userAssignedIdentityId string
param vmssIdentityName string

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2023-03-01' = {
  name: vmssName
  location: location
  identity: {
      type: 'UserAssigned'
      userAssignedIdentities: {
        '${userAssignedIdentityId}': {}
      }
  }
  sku: {
    name: 'Standard_B1ms'
    capacity: instanceCount
  }
  properties: {
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: vmssName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: 'UbuntuServer'
          sku: '18.04-LTS'
          version: 'latest'
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: '${vmssName}-nic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: subnetId
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
    upgradePolicy: {
      mode: 'Manual'
    }
  }
}

// Custom Script Extension to install Docker and run container
resource vmssExtension 'Microsoft.Compute/virtualMachineScaleSets/extensions@2023-03-01' = {
  parent: vmss
  name: 'installDockerAndApp'
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/bovrhovn/azure-alt-aks-static-ip-test/refs/heads/main/IaC/install-docker.sh'
      ]
      commandToExecute: 'bash install-docker.sh ${adminUsername} && echo "export ADMIN_USERNAME=${adminUsername}" >> /etc/profile.d/admin.sh'
    }
  }
}

// Existing ACR resource
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

resource vmssIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: vmssIdentityName
  scope: resourceGroup()
}

resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acr.id, vmssIdentity.id, 'acrpull')
  scope: acr
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull
    principalId: vmssIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}