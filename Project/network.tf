# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet"
    address_space       = ["11.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "publicsubnet" {
    name                 = "public-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["11.0.1.0/24"]
}

resource "azurerm_subnet" "privatesubnet" {
    name                 = "private-subnet"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["11.0.2.0/24"]

}