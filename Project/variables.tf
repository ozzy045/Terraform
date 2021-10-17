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
variable "vm_count" {
   default = 2
}
  variable "administrator_login" {
    type = string
    description = "postgres user name"
}        

  variable "administrator_login_password" {
    type = string
    description = "postgres users password"
  }