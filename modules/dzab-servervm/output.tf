output "nic" {
    description = "Id of the VM nic that was created."
    value = azurerm_network_interface.servervm-nic.id
}