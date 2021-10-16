output "password_vm" {
  value = var.admin_password
  description = "password for public VM"
  sensitive = true
}
