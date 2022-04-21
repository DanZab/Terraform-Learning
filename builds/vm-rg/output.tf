output "resource_group_id" {
    description = "Resource Group id for the Core RG"
    value = azurerm_resource_group.rg-tera-servervm.id
}

output "resource_group_name" {
    description = "Name of the VM"
    value = var.resource_group_name
}

output "resource_group_location" {
    description = "Name of the VM"
    value = var.resource_group_location
}