resource "azurerm_linux_web_app" "base_webapp" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.service_plan_id
  connection_string {
    name  = "connectionstrings"
    type  = "MySql"
    value = "Database=${var.databaseName};Data Source=${var.serverfullyQualifiedDomainName};User Id=${var.administratorLogin}@${var.serverName};Password=${var.administratorLoginPassword}"
  }
  site_config {}
}