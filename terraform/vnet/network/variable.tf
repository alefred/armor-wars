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

// vnet name
variable "training_vnet" {
  type = string
}

// Subnet and NSG
variable "training_snet_default" {
  type = string
}

variable "training_snet_dbwpriv" {
  type = string
}

variable "training_snet_dbwpub" {
  type = string
}

variable "training_nsg_dbwpriv" {
  type = string
}

variable "training_nsg_dbwpub" {
  type = string
}
