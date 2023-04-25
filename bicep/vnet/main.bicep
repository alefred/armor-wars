targetScope = 'subscription'

param location string = 'eastus2'
var rg_name = 'rg-bicep-01'
var vnet_name = 'vnet-spoke-bicep-01'

resource rgbicep01d 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rg_name
  location: location
}

module vnetm 'network.bicep' = {
  scope: rgbicep01d
  name: 'vnet_mod'
  params: {
    location: location
    vnetname: vnet_name
  }
}
