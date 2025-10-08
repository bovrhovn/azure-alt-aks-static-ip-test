param location string
param loadTestName string = 'myLoadTest'

resource loadTestResource 'Microsoft.LoadTestService/loadtests@2024-12-01-preview' = {
  name: loadTestName
  location: location  
  properties: {
    description: 'Azure Load Testing resource for performance testing'
  }
}
