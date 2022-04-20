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
  features {}
}

provider "azurerm" {
  alias           = "sub-payg-terraformtesting"
  subscription_id = "0a51535c-1009-4673-8654-6a78c9998f29"
  features {}
}
/*
data "terraform_remote_state" "data" {
  backend = "local"

  config = {
    path = "../../state/terraform.tfstate"
  }
}
*/
module "server-vm" {
  source = "../../modules/terraform-azurerm-dzab-servervm"
  providers = {
    azurerm = azurerm.sub-payg-terraformtesting
  }

  vm-name                = var.vm-name
  resourceGroup-name     = var.resource_group_name
  resourceGroup-location = var.resource_group_location
  subnet-id              = azurerm_subnet.subnet-tera-00.id
}

/*
# Module Block Template
module "The VM Name" {
  source = "./modules/dzab-servervm"
  providers = {
    azurerm = azurerm.sub-payg-terraformtesting
  }

  vm-name                = "WIN02"
  resourceGroup-name     = azurerm_resource_group.rg-tera-servervm.name
  resourceGroup-location = azurerm_resource_group.rg-tera-servervm.location
  subnet-id              = azurerm_subnet.subnet-tera-00.id
}
*/