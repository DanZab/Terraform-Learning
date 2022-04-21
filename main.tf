# Configure the Azure provider


# Next things to try:
# - Dynamic Disk Creation in module
#     Add a variable for additional disks that takes objects
#     Iterate through each disk object to create them in the module
# - Convert Core Resources to Modules
#     Import existing resource group
#     Import subscription ?

terraform {
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

# Core RG and Resources

resource "azurerm_resource_group" "rg-tera-core" {
  provider = azurerm.sub-payg-terraformtesting
  name     = "RG-TERA-Core"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet-tera" {
  provider            = azurerm.sub-payg-terraformtesting
  name                = "vnet-tera"
  address_space       = ["10.110.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg-tera-core.name
}

resource "azurerm_subnet" "subnet-tera-00" {
  provider             = azurerm.sub-payg-terraformtesting
  name                 = "subnet-tera-00"
  resource_group_name  = azurerm_resource_group.rg-tera-core.name
  virtual_network_name = azurerm_virtual_network.vnet-tera.name
  address_prefixes     = ["10.110.0.0/24"]
}

# VM Resource Group

resource "azurerm_resource_group" "rg-tera-servervm" {
  provider = azurerm.sub-payg-terraformtesting
  name     = "RG-TERA-ServerVM"
  location = "eastus"
}



module "WIN01" {
  source = "./modules/dzab-servervm"
  providers = {
    azurerm = azurerm.sub-payg-terraformtesting
  }

  vm-name                = "WIN01"
  resourceGroup-name     = azurerm_resource_group.rg-tera-servervm.name
  resourceGroup-location = azurerm_resource_group.rg-tera-servervm.location
  subnet-id              = azurerm_subnet.subnet-tera-00.id

  vm-disks = {
    "1" = 10
    "2" = 10
    "3" = 10
  }
}


/*
module "WIN02" {
  source = "./modules/dzab-servervm"
  providers = {
    azurerm = azurerm.sub-payg-terraformtesting
  }

  vm-name                = "WIN02"
  resourceGroup-name     = azurerm_resource_group.rg-tera-servervm.name
  resourceGroup-location = azurerm_resource_group.rg-tera-servervm.location
  subnet-id              = azurerm_subnet.subnet-tera-00.id
}

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