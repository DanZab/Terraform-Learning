# Required variables
variable "vm-name" {
    description = "Name of the VM, used to name all components related to that VM."
    type = string
}

variable "resourceGroup-name" {
    description = "Name of the Resource Group the VM will be created in."
    type = string
}

variable "resourceGroup-location" {
    description = "Location of the Resource Group the VM will be created in."
    type = string
}

variable "subnet-id" {
    description = "Id of the subnet the VM will get an address from."
    type = string
}

variable "vm_data_disks" {
  description = "(Optional) A map consisting of numeric disk ids and their corresponding sizes in GB."
  type        = map(any)
  default     = null
}

variable "vm_data_disks_count" {
  description = "(Optional) A map consisting of numeric disk ids and their corresponding sizes in GB."
  type        = map(any)
  default     = null
}