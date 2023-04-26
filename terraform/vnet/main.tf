// Resource group definition
resource "azurerm_resource_group" "rg" {
  name = local.rg
  location = local.location
}

// Network Module
module "infra_network" {
  source = "./network"
  rg_name = azurerm_resource_group.rg.name
  location = local.location
  vnet = local.vnet
}