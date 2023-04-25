provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
}

module "service_plan" {
  source              = "./azurerm_service_plan"
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_name   = local.service_plan_name
  location            = local.location
}

module "mysql_db" {
  source                     = "./azurerm_mysql_server"
  administratorLogin         = local.admin_login
  administratorLoginPassword = var.admin_pass
  databaseName               = local.db_name
  serverName                 = local.db_server_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = local.location
}

module "web_app" {
  source                         = "./azurerm_linux_web_app"
  location                       = local.location
  resource_group_name            = azurerm_resource_group.rg.name
  service_plan_id                = module.service_plan.service_plan_id
  webapp_name                    = local.webapp_name
  administratorLogin             = local.admin_login
  administratorLoginPassword     = var.admin_pass
  serverfullyQualifiedDomainName = module.mysql_db.fqdn
  serverName                     = local.db_server_name
  databaseName                   = local.db_name
}