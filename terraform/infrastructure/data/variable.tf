variable "rg_name" {
  type = string
}

// General variables
variable "training_location" {
  type = string
}

variable "training_owner" {
  type = string
}

// Storage Account Name
variable "training_storageaccount_name" {
  type = string
}

// Databricks Workspace name
variable "training_databricks_name" {
  type = string
}

// vnet id
variable "training_vnet_id" {
  type = string
}

// Subnet names
variable "training_snet_default" {
  type = string
}

variable "training_snet_dbwpriv" {
  type = string
}

variable "training_snet_dbwpub" {
  type = string
}

// Subnet nsgs
variable "training_nsg_dbwpriv_id" {
  type = string
}

variable "training_nsg_dbwpub_id" {
  type = string
}


