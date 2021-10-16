variable "location" {
  default = "west europe" 
  description = "Region"
}

variable "vm_size" {
    default = "Standard_B1s"
    description = "VM Size"
}

variable "admin_username" {
  type = string
  description = "VM username"
}

variable "admin_password" {
  type = string
  description = "VM password"
}