targetScope = 'subscription'

param location string = 'eastus2'
param app_name string = 'iacwars'
@secure()
param admin_pass string
var rg_name = 'rg-${app_name}-bicep-02'
var webapp_name = 'app-${app_name}-bicep-01'
var service_plan_name = 'asp-${app_name}-bicep-01'
var admin_login = 'adminla'
var db_name = 'db-${app_name}-bicep-01'
var db_server_name = 'srv-${db_name}'

resource rgbicep01d 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rg_name
  location: location
}

module aspm 'Web/serverfarms.bicep' = {
  scope: rgbicep01d
  name: 'asp-mod'
  params: {
    hostingPlanName: service_plan_name
    location: location
  }
}

module dbm 'DBforMySQL/servers.bicep' ={
  scope: rgbicep01d
  name: 'db-mod'
  params: {
    administratorLogin: admin_login
    administratorLoginPassword: admin_pass
    databaseName: db_name
    serverName: db_server_name
    location: location
  }
}
  
module webm 'Web/sites.bicep' = {
  scope: rgbicep01d
  name: 'app-mod'
  params: {
    administratorLogin: 'adminla'
    administratorLoginPassword: '@##$!@'
    databaseName: db_name
    hostingPlanId: aspm.outputs.id
    location: location
    serverfullyQualifiedDomainName: dbm.outputs.fqdn
    serverName: db_server_name
    siteName: webapp_name
  }
}
