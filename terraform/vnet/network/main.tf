//Network definition
resource "azurerm_virtual_network" "network-vnet" {
  name = var.training_vnet
  address_space = [ "192.168.0.0/16" ]
  resource_group_name = var.rg_name
  location = var.training_location

  tags = {
    Owner = var.training_owner
  }
}

resource "azurerm_subnet" "network-subnet-default" {
    name = var.training_snet_default
    address_prefixes = [ "192.168.1.0/24" ]
    virtual_network_name = azurerm_virtual_network.network-vnet.name
    resource_group_name = var.rg_name
    service_endpoints = [ "Microsoft.Storage" ]
}

resource "azurerm_subnet" "network-subnet-dbwprivate" {
    name = var.training_snet_dbwpriv
    address_prefixes = [ "192.168.2.0/24" ]
    virtual_network_name = azurerm_virtual_network.network-vnet.name
    resource_group_name = var.rg_name
    
    delegation {
      name = "dbwprivate"
      service_delegation {
        name = "Microsoft.Databricks/workspaces"
      }
    }
}

resource "azurerm_subnet" "network-subnet-dbwpublic" {
    name = var.training_snet_dbwpub
    address_prefixes = [ "192.168.3.0/24" ]
    virtual_network_name = azurerm_virtual_network.network-vnet.name
    resource_group_name = var.rg_name
    
    delegation {
      name = "dbwpublic"
      service_delegation {
        name = "Microsoft.Databricks/workspaces"
      }
    }
}

resource "azurerm_network_security_group" "nsg-dbwpublic" {
  name = var.training_nsg_dbwpub
  resource_group_name = var.rg_name
  location = var.training_location
}

resource "azurerm_subnet_network_security_group_association" "association-dbwpub-nsg" {
  network_security_group_id = azurerm_network_security_group.nsg-dbwpublic.id
  subnet_id = azurerm_subnet.network-subnet-dbwpublic.id
}

resource "azurerm_network_security_group" "nsg-dbwprivate" {
  name = var.training_nsg_dbwpriv
  resource_group_name = var.rg_name
  location = var.training_location
}

resource "azurerm_subnet_network_security_group_association" "association-dbwpriv-nsg" {
  network_security_group_id = azurerm_network_security_group.nsg-dbwprivate.id
  subnet_id = azurerm_subnet.network-subnet-dbwprivate.id
}
