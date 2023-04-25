param location string
param vnetname string

resource vnetd 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetname
  location: location
  properties: {
    addressSpace:{
      addressPrefixes:[
        '192.168.0.0/16'
      ]
    }
  }

}

output vnetId string = vnetd.id
