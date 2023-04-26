//Network definition
resource "azurerm_virtual_network" "network-vnet" {
  name = var.vnet
  address_space = [ "192.168.0.0/16" ]
  resource_group_name = var.rg_name
  location = var.location
}
