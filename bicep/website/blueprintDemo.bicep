param siteName string
param administratorLogin string
param databaseSkucapacity int = 2
param databaseSkuName string = 'GP_Gen5_2'
param databaseSkuSizeMB int = 51200
param databaseSkuTier string = 'GeneralPurpose'
param mySqlVersion string = '8.0'
param location string = resourceGroup().location
param databaseSkuFamily string = 'Gen5'

@secure()
param administratorLoginPassword string

var databaseName = '${siteName}-database'
var serverName = '${siteName}-server'
var hostingPlanName = '${siteName}-serviceplan'

resource hostingPlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: hostingPlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
}

resource website 'Microsoft.Web/sites@2020-06-01' = {
  name: siteName
  location: location
  properties: {
    serverFarmId: hostingPlan.id
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    defaultConnection: {
      value: 'Database=${databaseName};Data Source=${server.properties.fullyQualifiedDomainName};User Id=${administratorLogin}@${serverName};Password=${administratorLoginPassword}'
      type: 'MySql'
    }
  }
}

resource server 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  location: location
  name: serverName
  sku: {
    name: databaseSkuName
    tier: databaseSkuTier
    capacity: databaseSkucapacity
    size: string(databaseSkuSizeMB)
    family: databaseSkuFamily
  }
  properties: {
    createMode: 'Default'
    version: mySqlVersion
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    storageProfile: {
      storageMB: databaseSkuSizeMB
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    sslEnforcement: 'Disabled'
  }
}

resource firewallRules 'Microsoft.DBforMySQL/servers/firewallrules@2017-12-01' = {
  parent: server
  name: 'AllowAzureIPs'
  dependsOn: [
    database
  ]
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource database 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = {
  parent: server
  name: databaseName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}
