param dnsZoneName string
param location string = 'global'

resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = {
  name: dnsZoneName
  location: location
}

output dnsZoneId string = dnsZone.id