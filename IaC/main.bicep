param location string = resourceGroup().location
param vnetName string = 'myVnet'
param aksName string = 'myAks'
param dnsZoneName string = 'mydomain.com'
param lbName string = 'myLb'
param vmssName string = 'myVmss'
param adminUsername string
@secure()
param adminPassword string
param acrName string = 'myAcr'
param agentVMSize string = 'Standard_B2ms'
param loadTestName string = 'myLoadTest'
param appInsightsName string = 'myappinsights'
param instanceCount int = 2

module vnetMod './vnet.bicep' = {
  name: 'vnetDeployment'
  params: {
    vnetName: vnetName
    location: location
  }
}

module acrMod './acr.bicep' = {
  name: 'acrDeployment'
  params: {
    acrName: acrName
    location: location
  }
}

module aksMod './aks.bicep' = {
  name: 'aksDeployment'
  params: {
    aksName: aksName
    location: location
    dnsPrefix: 'aksdns'
    agentVMSize: agentVMSize    
    vnetSubnetId: vnetMod.outputs.aksSubnetId        
    acrName: acrName
  }
}

module lbMod './loadbalancer.bicep' = {
  name: 'lbDeployment'
  params: {
    lbName: lbName
    location: location
    vnetName: vnetName
    subnetName: 'aks-subnet'
  }
}

module dnsMod './dnszone.bicep' = {
  name: 'dnsDeployment'
  params: {
    dnsZoneName: dnsZoneName
  }
}

module vmssMod './vmss.bicep' = {
  name: 'vmssDeployment'
  params: {
    vmssName: vmssName
    location: location
    subnetId: vnetMod.outputs.vmssSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
    acrName: acrName    
    instanceCount: instanceCount    
  }
}

module loadTestMod './loadtest.bicep' = {
  name: 'loadTestDeployment'
  params: {
    location: location
    loadTestName: loadTestName
  }
}

module appInsights './appInsights.bicep' = {
  name: 'appInsightsDeployment'
  params: {
    appInsightsName: appInsightsName
    location: location
    applicationType: 'web'
  }
}