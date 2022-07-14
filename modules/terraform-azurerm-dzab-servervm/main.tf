locals {
  # Can't pass a null value into for each, this creates an empty set if
  # var.vm-data-disks is null
  data_disks = var.vm_data_disks == null ? {} : var.vm_data_disks
  disk_keys  = keys(local.data_disks)

  # The lun_map variable generates a list consisting of maps:
  # lun_map = [
  #    {datadisk_name="VMNAME-DSK-01",lun=10},
  #    {datadisk_name="VMNAME-DSK-02",lun=11},
  #    {datadisk_name="VMNAME-DSK-03",lun=12},
  # ]
  # that is used in the luns variable to create a map for the loop:
  # luns = {
  #  VMNAME-DSK-01 = 10
  #  VMNAME-DSK-02 = 11
  #  VMNAME-DSK-03 = 12
  # }

  lun_map = [for key, value in local.data_disks : {
    datadisk_name = format("${var.name}-DSK-%02d", key)
    lun           = tonumber(key)
  }]
  luns = { for k in local.lun_map : k.datadisk_name => k.lun }
}

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

module "data_disk" {
  source = "../terraform-azurerm-dzab-datadisk"

  for_each = local.data_disks

  resource_group            = var.resourceGroup-name
  region                    = var.resourceGroup-location
  vm_id                     = azurerm_windows_virtual_machine.servervm.id

  disk_name                 = format("${var.name}-DSK-%02d", each.key)
  disk_size                 = each.value
  lun                       = lookup(local.luns, format("${var.name}-DSK-%02d", each.key))
}