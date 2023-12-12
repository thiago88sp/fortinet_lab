
#--------------------------------------------------------------------------#
#  VM - A (East US)                                                        #
#--------------------------------------------------------------------------#
#resource "azurerm_public_ip" "pip-a" {
#  name                = "${var.prefix-a}-pip-a"
#  resource_group_name = azurerm_resource_group.myterraformgroup.name
#  location            = var.location-a
#  allocation_method   = "Dynamic"
#}

resource "azurerm_network_interface" "nic-a" {
  name                = "${var.prefix-a}-nic-a"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  location            = var.location-a

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.privatesubnet-a.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.pip-a.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-a" {
  name                            = "${var.prefix-a}-eastus"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location-a
  size                            = "Standard_B2s"
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic-a.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}


#--------------------------------------------------------------------------#
#  VM - B (East US)                                                        #
#--------------------------------------------------------------------------#
#resource "azurerm_public_ip" "pip-b" {
#  name                = "${var.prefix-b}-pip-b"
#  resource_group_name = azurerm_resource_group.myterraformgroup.name
#  location            = var.location-b
#  allocation_method   = "Dynamic"
#}

resource "azurerm_network_interface" "nic-b" {
  name                = "${var.prefix-b}-nic-b"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  location            = var.location-b

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.privatesubnet-b.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = azurerm_public_ip.pip-b.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-b" {
  name                            = "${var.prefix-b}-westus"
  resource_group_name             = azurerm_resource_group.myterraformgroup.name
  location                        = var.location-b
  size                            = "Standard_B2s"
  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic-b.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

