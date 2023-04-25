param siteName string
param location string
param hostingPlanId string
param databaseName string
param serverfullyQualifiedDomainName string
param administratorLogin string
param serverName string
@secure()
param administratorLoginPassword string


resource website 'Microsoft.Web/sites@2020-06-01' = {
  name: siteName
  location: location
  properties: {
    serverFarmId: hostingPlanId
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    defaultConnection: {
      value: 'Database=${databaseName};Data Source=${serverfullyQualifiedDomainName};User Id=${administratorLogin}@${serverName};Password=${administratorLoginPassword}'
      type: 'MySql'
    }
  }
}
