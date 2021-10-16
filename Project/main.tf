#create resource group

resource "azurerm_resource_group" "rg" {
  name     = "terraform-project"
  location = "west europe"
}

#create public vm's with module
module "virtual_machine" {
  source = "../modules/vm-module"

  resource_group_name = azurerm_resource_group.rg.name
  vm_count = var.vm_count
  VM_name = "web-server"
  location = var.location
  vm_size = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  nic_name = "public-nic"
  subnet_id = azurerm_subnet.publicsubnet.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}

#create blob storage

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}