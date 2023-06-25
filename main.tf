# Loading provider
provider "azurerm" {
  features {}
}

# Create virtual resource group
resource "azurerm_resource_group" "swiss_rg" {
  name     = "swiss_group"
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = "virtual_network"
  address_space       = var.v_net
  location            = azurerm_resource_group.swiss_rg.location
  resource_group_name = azurerm_resource_group.swiss_rg.name
}

# Create Security groups (NSG)
resource "azurerm_network_security_group" "network_security_group" {
  name                = "network_security_group"
  resource_group_name = azurerm_resource_group.swiss_rg.name
  location            = azurerm_resource_group.swiss_rg.location

  # Configure NSG rules to deny incoming traffic and allow outgoing traffic
  security_rule {
    name                       = "DenyIncoming"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowOutgoing"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}
