terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.9.0"
    }
  }
}

resource "azurerm_managed_disk" "managed_disk" {
  name                 = var.disk_name
  disk_size_gb         = var.disk_size
  resource_group_name  = var.resource_group
  location             = var.region
  storage_account_type = var.disk_storage_account_type
  create_option        = var.disk_create_option
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  virtual_machine_id = var.vm_id
  managed_disk_id    = azurerm_managed_disk.managed_disk.id
  caching            = var.disk_caching
  lun                = var.lun

  depends_on = [
    azurerm_managed_disk.managed_disk
  ]
}