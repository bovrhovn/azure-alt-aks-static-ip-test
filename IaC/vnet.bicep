param vnetName string
param location string
param addressPrefix string = '10.0.0.0/8'
param aksSubnetPrefix string = '10.1.0.0/16'
param vmssSubnetPrefix string = '10.2.0.0/16'

resource vnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressPrefix]
    }
    subnets: [
      {
        name: 'aks-subnet'
        properties: {
          addressPrefix: aksSubnetPrefix
        }
      }
      {
        name: 'vmss-subnet'
        properties: {
          addressPrefix: vmssSubnetPrefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output aksSubnetId string = vnet.properties.subnets[0].id
output vmssSubnetId string = vnet.properties.subnets[1].id