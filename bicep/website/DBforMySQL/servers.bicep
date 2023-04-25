param administratorLogin string
param databaseSkucapacity int = 2
param databaseSkuName string = 'GP_Gen5_2'
param databaseSkuSizeMB int = 51200
param databaseSkuTier string = 'GeneralPurpose'
param mySqlVersion string = '8.0'
param location string = resourceGroup().location
param databaseSkuFamily string = 'Gen5'
param serverName string
param databaseName string
@secure()
param administratorLoginPassword string


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

output fqdn string = server.properties.fullyQualifiedDomainName
