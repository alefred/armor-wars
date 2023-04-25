resource "azurerm_mysql_server" "base_dbserver" {
  name                = var.serverName
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.administratorLogin
  administrator_login_password = var.administratorLoginPassword

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "8.0"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "base_db" {
  name                = var.databaseName
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.base_dbserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "base_rule" {
  name                = "AllowAzureIPs"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.base_dbserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}