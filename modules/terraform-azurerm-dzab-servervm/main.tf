# Need to figure out how to reference the Resource Group created elsewhere

resource "azurerm_network_interface" "servervm-nic" {
  name                = "${var.vm-name}-nic"
  location            = var.resourceGroup-location
  resource_group_name = var.resourceGroup-name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet-id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "servervm-disk-d" {
  name                 = "${var.vm-name}-disk-d"
  location             = var.resourceGroup-location
  resource_group_name  = var.resourceGroup-name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "20"
}

resource "azurerm_windows_virtual_machine" "servervm" {
  name                = var.vm-name
  resource_group_name = var.resourceGroup-name
  location            = var.resourceGroup-location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"

  network_interface_ids = [
    azurerm_network_interface.servervm-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.vm-name}-disk-c"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk-d-attach" {
  managed_disk_id    = azurerm_managed_disk.servervm-disk-d.id
  virtual_machine_id = azurerm_windows_virtual_machine.servervm.id
  lun                = "10"
  caching            = "ReadWrite"
}