terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~>3.4.0"
        }
        databricks = {
            source = "databrickslabs/databricks"
            version = "0.5.6"
        }
    }
    /* backend "azurerm" {
    } */
}

provider "azurerm" {
    features {}
}
