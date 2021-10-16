variable "location" {
  type = string
  description = "Region"
}

variable "vm_size" {
    type = string
    description = "VM Size"
}

variable "resource_group_name" {
    type = string
    description = "resource group name"
}

variable "VM_name"{
    type = string
    description = "vm name"
}


variable "nic_name" {
    type = string
    description = "nic name"
}
variable "subnet_id" {
    type = string
    description = "subnet id"
}

variable "admin_username" {
  type = string
  description = "VM username"
}

variable "admin_password" {
  type = string
  description = "VM password"
}

variable "backend_address_pool_id" {
    type = string
    description = "backend address pool id"
}