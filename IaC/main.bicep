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
param identityName string = 'myAksIdentity'
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

module identityMod './identity.bicep' = {
  name: 'identityDeployment'
  params: {
    identityName: identityName
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
    aksIdentityName: identityName
    vnetSubnetId: vnetMod.outputs.aksSubnetId
    userAssignedIdentityId: identityMod.outputs.identityId    
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
    userAssignedIdentityId: identityMod.outputs.identityId
    vmssIdentityName: identityName
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