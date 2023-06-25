# Resources for bastion
#-----------------------

# Create subnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.swiss_rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.bastion_subnet_network
}

# Create public IP for bastion
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastion_public_ip"
  location            = azurerm_resource_group.swiss_rg.location
  resource_group_name = azurerm_resource_group.swiss_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Create bastion
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.swiss_rg.location
  resource_group_name = azurerm_resource_group.swiss_rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}
