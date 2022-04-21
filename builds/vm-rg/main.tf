# Configure the Azure provider


# Next things to try:
# - Dynamic Disk Creation in module
#     Add a variable for additional disks that takes objects
#     Iterate through each disk object to create them in the module
# - Convert Core Resources to Modules
#     Import existing resource group
#     Import subscription ?

terraform {
  backend "local" {
    path = "../../state/terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  alias           = "sub-payg-terraformtesting"
  subscription_id = "0a51535c-1009-4673-8654-6a78c9998f29"
  features {}
}

# VM Resource Group

resource "azurerm_resource_group" "rg-tera-servervm" {
  provider = azurerm.sub-payg-terraformtesting
  name     = var.resource_group_name
  location = var.resource_group_location
}
