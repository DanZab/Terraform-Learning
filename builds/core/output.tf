output "rg_id" {
    description = "Resource Group id for the Core RG"
    value = azurerm_resource_group.rg-tera-core.id
}

output "vnet_id" {
    description = "Virtual Network id"
    value = azurerm_virtual_network.vnet-tera.id
}

output "vnet_name" {
    description = "Virtual Network name"
    value = azurerm_virtual_network.vnet-tera.name
}

output "vnet_address_space" {
    description = "Virtual Network address space"
    value = azurerm_virtual_network.vnet-tera.address_space
}

output "vnet_guid" {
    description = "Virtual Network guid"
    value = azurerm_virtual_network.vnet-tera.guid
}

output "subnet_id" {
    description = "Subnet id"
    value = azurerm_subnet.subnet-tera-00.id
}

output "subnet_name" {
    description = "Subnet name"
    value = azurerm_subnet.subnet-tera-00.name
}

output "subnet_address_prefixes" {
    description = "Subnet address prefixes"
    value = azurerm_subnet.subnet-tera-00.address_prefixes
}
