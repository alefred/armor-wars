// Resource group definition
resource "azurerm_resource_group" "trainingenv-rg" {
  name = local.training_rg
  location = var.training_location

  tags = {
    Owner = var.training_owner
  }
}

//Role assigment
# data "azurerm_client_config" "example" {
# }

# resource "azurerm_role_assignment" "example" {
#   scope = azurerm_resource_group.trainingenv-rg.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = data.azurerm_client_config.example.object_id
# }


// Network Module
module "infra_network" {
  source = "./network"
  rg_name = azurerm_resource_group.trainingenv-rg.name
  training_owner = var.training_owner
  training_location = var.training_location
  training_vnet = local.training_vnet
  training_snet_default = local.training_snet_default
  training_snet_dbwpriv = local.training_snet_dbwpriv
  training_snet_dbwpub =  local.training_snet_dbwpub
  training_nsg_dbwpriv = local.training_nsg_dbwpriv
  training_nsg_dbwpub = local.training_nsg_dbwpub
}

// Data Module
module "infra_data" {
  source = "./data"  
  depends_on = [
    module.infra_network
  ]
  rg_name = azurerm_resource_group.trainingenv-rg.name
  training_owner = var.training_owner
  training_location = var.training_location
  training_snet_dbwpriv = local.training_snet_dbwpriv
  training_snet_dbwpub = local.training_snet_dbwpub
  training_databricks_name = local.training_databricks_name
  training_storageaccount_name = local.training_storageaccount_name
  training_vnet_id = module.infra_network.vnet_id
  training_nsg_dbwpriv_id = module.infra_network.nsgpriv_id
  training_nsg_dbwpub_id = module.infra_network.nsgpub_id
  training_snet_default = module.infra_network.defaultsnet_id
}
