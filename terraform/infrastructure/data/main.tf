//Databricks Definition
resource "azurerm_databricks_workspace" "dbw-infra" {
  name                = var.training_databricks_name
  resource_group_name = var.rg_name
  location            = var.training_location
  sku                 = "premium"

  custom_parameters {
    public_subnet_name = var.training_snet_dbwpub
    private_subnet_name = var.training_snet_dbwpriv
    public_subnet_network_security_group_association_id = var.training_nsg_dbwpub_id
    private_subnet_network_security_group_association_id = var.training_nsg_dbwpriv_id
    virtual_network_id = var.training_vnet_id
  }

  tags = {
    Owner = var.training_owner
  }
}


// Storage Account Definition 
resource "azurerm_storage_account" "st-infra" {
  name = regex("[a-z,0-9]+",lower(var.training_storageaccount_name))
  resource_group_name = var.rg_name
  location = var.training_location
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  is_hns_enabled = true
  min_tls_version = "TLS1_2"
  allow_nested_items_to_be_public = false

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [ 
        var.training_snet_default
      ]
    ip_rules = [
        "83.82.9.26",
        "62.41.23.0/30",
        "51.136.82.0/29",
        "52.156.252.64/29",
        "213.19.193.12/30"
     ]
  }

  tags = {
    Owner = var.training_owner
  }
}

// Role Assigment
# data "azurerm_client_config" "example" {
# }

# resource "azurerm_role_assignment" "example" {
#   # scope                = data.azurerm_subscription.primary.id
#   scope = azurerm_storage_account.st-infra.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = data.azurerm_client_config.example.object_id
# }

// Storage container
resource "azurerm_storage_container" "container-infra" {
  name = "new-container"
  storage_account_name = azurerm_storage_account.st-infra.name
  container_access_type = "private"
}
