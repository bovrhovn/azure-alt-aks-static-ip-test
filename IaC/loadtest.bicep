param location string
param loadTestName string = 'myLoadTest'

resource loadTestResource 'Microsoft.LoadTestService/loadTests@2022-06-01-preview' = {
  name: loadTestName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    description: 'Azure Load Testing resource for performance testing'
  }
}