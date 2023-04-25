locals {
  location          = "eastus2"
  app_name          = "iacwars"
  rg_name           = "rg-${local.app_name}-terraform-02"
  webapp_name       = "app-${local.app_name}-terraform-01"
  service_plan_name = "asp-${local.app_name}-terraform-01"
  admin_login       = "adminla"
  admin_pass        = "Password01$"
  db_name           = "db-${local.app_name}-terraform-01"
  db_server_name    = "srv-${local.db_name}"
}