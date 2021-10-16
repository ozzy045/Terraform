resource "azurerm_resource_group" "rg" {
  name     = "terraform-project"
  location = "west europe"
}

module "virtual_machine" {
  source = "../modules/vm-module"

  resource_group_name = azurerm_resource_group.rg.name
  
  VM_name = "web-server-1"
  location = var.location
  vm_size = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  nic_name = "public-nic-1"
  subnet_id = azurerm_subnet.publicsubnet.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}