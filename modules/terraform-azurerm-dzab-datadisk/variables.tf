variable "resource_group" {
  description = "(Required) name of the resource group the disk will be created in."
  type        = string
}

variable "region" {
  description = "(Optional) Azure region. If not specified, defaults to 'eastus'."
  type        = string
  default     = "eastus"
}

variable "disk_name" {
  description = "(Required) name of the managed disk in Azure. Ex; 'APPCSDB-E1P1-DSK-01'."
  type        = string
}

variable "disk_size" {
  description = "(Required) disk size in GB."
  type        = number
}

variable "disk_storage_account_type" {
  description = "(Optional) The type of storage to use for the managed disk."
  type        = string
  default     = "Standard_LRS"
}

variable "disk_create_option" {
  description = "(Optional) What type of disk to create, defaults to 'Empty'."
  type        = string
  default     = "Empty"
}

variable "vm_id" {
  description = "(Required) The id of the Virtual Machine to attach the disk to."
  type        = string
}

variable "disk_caching" {
  description = "(Optional) Specifies the caching requirements for this Data Disk, defaults to 'ReadWrite'. Possible values include 'None', 'ReadOnly' and 'ReadWrite'."
  type        = string
  default     = "ReadWrite"
}

variable "lun" {
  description = "(Required) The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine."
  type        = number
}

variable "tags" {
  description = "(Optional) A map consisting of tags to be applied to the resource."
  type        = map(any)
  default     = null
}


/*
disk_name                 = 
disk_size                 = 
resource_group            = 
region                    = 
disk_storage_account_type = 
disk_create_option        = 
*/