# Create network interface
resource "azurerm_network_interface" "nic_vm" {
    name                      = var.nic_name
    location                  = var.location
    resource_group_name       = var.resource_group_name

    ip_configuration {
        name                          = "internal-vm"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

# Create virtual machines
resource "azurerm_linux_virtual_machine" "vm" {
    name                  = var.VM_name
    resource_group_name   = var.resource_group_name
    location              = var.location
    size                  = var.vm_size

    network_interface_ids = [ 
         azurerm_network_interface.nic_vm.id,
    ]

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

        computer_name  = "vm-host"
        admin_username = var.admin_username
        admin_password = var.admin_password

        disable_password_authentication = false


}

resource "azurerm_network_interface_backend_address_pool_association" "vm-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm.id
  ip_configuration_name   = "internal-vm"
  backend_address_pool_id = var.backend_address_pool_id
}
