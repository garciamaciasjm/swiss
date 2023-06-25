# Resources for firewall
#-----------------------

# Create subnet for firewall
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.swiss_rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.firewall_subnet_network
}

#Create public IP for firewall
resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "firewall_public_ip"
  location            = azurerm_resource_group.swiss_rg.location
  resource_group_name = azurerm_resource_group.swiss_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create firewall
resource "azurerm_firewall" "firewall" {
  name                = "firewall"
  location            = azurerm_resource_group.swiss_rg.location
  resource_group_name = azurerm_resource_group.swiss_rg.name
  sku_tier            = "Standard"
  sku_name            = "AZFW_VNet" #  options here are AZFW_Hub or AZFW_VNet. Use this if you want to use the Secure Virtual Hub operating method.

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
}

#Firewall Policy
resource "azurerm_firewall_policy" "fw-pol01" {
  name                = "firewall-policy01"
  resource_group_name = azurerm_resource_group.swiss_rg.name
  location            = var.location
}

# Create rules
resource "azurerm_firewall_network_rule_collection" "fw-rule-outbound" {
  name                = "firewall_rule_allow_all_outbound"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.swiss_rg.name
  priority            = 100
  action              = "Allow"
  rule {
    name                  = "AllowAllOutbound"
    source_addresses      = ["*"]
    destination_addresses = ["*"]
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
}

resource "azurerm_firewall_network_rule_collection" "fw-rule-inbound-http" {
  name                = "firewall_rule_inbound_http"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.swiss_rg.name
  priority            = 101
  action              = "Allow"
  rule {
    name                  = "inbound_http_https"
    source_addresses      = ["*"]
    destination_addresses = var.vm_subnet_network
    destination_ports     = ["80", "443"]
    protocols             = ["TCP"]
  }
}
