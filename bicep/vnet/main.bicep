targetScope = 'subscription'

param location string = 'eastus2'

resource rgbicep01d 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-bicep-02'
  location: location
}

module vnetm 'network.bicep' = {
  scope: rgbicep01d
  name: 'vnetd'
  params: {
    location: location
    vnetname: 'vnet01'
  }
}
