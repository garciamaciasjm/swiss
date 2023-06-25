
# Resources for Virtual Machines
#-------------------------------

# Create subnet for virtual machine
resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm_subnet"
  resource_group_name  = azurerm_resource_group.swiss_rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.vm_subnet_network
}

# Create network interface
resource "azurerm_network_interface" "network_nic" {
  name                = "network_nic"
  resource_group_name = azurerm_resource_group.swiss_rg.name
  location            = azurerm_resource_group.swiss_rg.location

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create Virtual Machine
resource "azurerm_linux_virtual_machine" "ubuntu_vm" {
  count                           = var.vm_count # Count Value read from variable
  name                            = "${var.prefix}-${count.index}"
  resource_group_name             = azurerm_resource_group.swiss_rg.name
  location                        = azurerm_resource_group.swiss_rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.network_nic.id
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = var.vm_os_version
  }

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
