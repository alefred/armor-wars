
output "vnet_id" {
  value = azurerm_virtual_network.network-vnet.id
}

output "nsgpub_id" {
  value = azurerm_subnet.network-subnet-dbwpublic.id
}

output "nsgpriv_id" {
  value = azurerm_subnet.network-subnet-dbwprivate.id
}

output "defaultsnet_id" {
  value = azurerm_subnet.network-subnet-default.id
}