variable "lab_name" {
  default = "osterhood"
  type = string
}

variable "training_location" {
  default = "westeurope"
  type = string
}

variable "training_owner" {
  default = "alefred"
  type = string
}

variable "tags" {
  type = map
}

locals {
  # training_rg = "rg-${var.lab_name}-dev-we-01"
  training_rg = var.tags["rgname"]
  training_vnet = "vnet-${var.lab_name}-dev-we-01"
  training_snet_default = "snet-default-${var.lab_name}-dev-we-01"
  training_snet_dbwpriv = "snet-dbwpriv-${var.lab_name}-dev-we-01"
  training_snet_dbwpub = "snet-dbwpub-${var.lab_name}-dev-we-01"
  training_nsg_dbwpriv = "nsg-dbwpriv-${var.lab_name}-dev-we-01"
  training_nsg_dbwpub = "nsg-dbwpub-${var.lab_name}-dev-we-01"
  training_databricks_name = "dbw-${var.lab_name}-dev-we-01"
  training_storageaccount_name = "st${var.lab_name}devwe01"
}