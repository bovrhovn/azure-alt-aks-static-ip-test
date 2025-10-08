@description('Name of the Application Insights resource')
param appInsightsName string

@description('Location for the Application Insights resource')
param location string = resourceGroup().location

@description('Application type for Application Insights (e.g., web, other)')
param applicationType string = 'web'

@description('Optional: Tags for the resource')
param tags object = {}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: applicationType
  properties: {
    Application_Type: applicationType
  }
  tags: tags
}

output appInsightsId string = appInsights.id
output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
output appInsightsConnectionString string = appInsights.properties.ConnectionString
