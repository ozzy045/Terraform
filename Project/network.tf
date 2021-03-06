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

# Create Network Security Group and rule
resource "azurerm_network_security_group" "public_nsg" {
    name                = "public-ngs"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                       = "SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "InBound-8080"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "OutBound-8080"
        priority                   = 102
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    depends_on = [
        azurerm_resource_group.rg,
    ]
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "private-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "inbound-5432"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = "11.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "outbound-5432"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Rule-22"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "deny"
    protocol                   = "*"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

    
  }

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

# Connect the security group to the subnets
resource "azurerm_subnet_network_security_group_association" "public_nsg_assoc" {
    subnet_id      = azurerm_subnet.publicsubnet.id
    network_security_group_id = azurerm_network_security_group.public_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_assoc" {
    subnet_id      = azurerm_subnet.privatesubnet.id
    network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = "nat-Gateway"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "assoc_private_nat" {
  subnet_id      = azurerm_subnet.privatesubnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}
resource "azurerm_subnet_nat_gateway_association" "assoc_public_nat" {
  subnet_id      = azurerm_subnet.publicsubnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}