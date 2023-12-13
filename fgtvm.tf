#--------------------------------------------------------------------------#
#  Fortigate VM - A (East US)                                              #
#--------------------------------------------------------------------------#

#---------------------- Image VM ------------------------------------------#

resource "azurerm_image" "custom-a" {
  count               = var.custom-a ? 1 : 0
  name                = var.custom_image_name
  resource_group_name = var.custom_image_resource_group_name
  location            = var.location-a
  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = var.customuri
    size_gb  = 2
  }
}

#---------------------- Fortigate VM --------------------------------------#

resource "azurerm_virtual_machine" "customfgtvm-a" {
  count                        = var.custom-a ? 1 : 0
  name                         = "fgtvm-a"
  location                     = var.location-a
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.fgtport1-a.id, azurerm_network_interface.fgtport2-a.id]
  primary_network_interface_id = azurerm_network_interface.fgtport1-a.id
  vm_size                      = var.size


  storage_image_reference {
    id = var.custom-a ? element(azurerm_image.custom-a.*.id, 0) : null
  }

  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk-a"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgtvm-a"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgtvm-a.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #boot_diagnostics {
  #  enabled     = true
  #  storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  #}

  tags = {
    environment = "Terraform Demo"
  }
}


resource "azurerm_virtual_machine" "fgtvm-a" {
  count                        = var.custom-a ? 0 : 1
  name                         = "fgtvm-a"
  location                     = var.location-a
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.fgtport1-a.id, azurerm_network_interface.fgtport2-a.id]
  primary_network_interface_id = azurerm_network_interface.fgtport1-a.id
  vm_size                      = var.size
  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.fgtversion
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "osDisk-a"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk-a"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgtvm-a"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgtvm-a.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #boot_diagnostics {
  #  enabled     = true
  #  storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  #}

  tags = {
    environment = "Terraform Demo"
  }
}

data "template_file" "fgtvm-a" {
  template = file(var.bootstrap-fgtvm-a)
  vars = {
    type         = var.license_type
    license_file = var.license-a
  }
}



#--------------------------------------------------------------------------#

#--------------------------------------------------------------------------#
#  Fortigate VM - B (West US)                                              #
#--------------------------------------------------------------------------#

#---------------------- Image VM ------------------------------------------#

resource "azurerm_image" "custom-b" {
  count               = var.custom-b ? 1 : 0
  name                = var.custom_image_name
  resource_group_name = var.custom_image_resource_group_name
  location            = var.location-b
  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = var.customuri
    size_gb  = 2
  }
}

#---------------------- Fortigate VM --------------------------------------#

resource "azurerm_virtual_machine" "customfgtvm-b" {
  count                        = var.custom-b ? 1 : 0
  name                         = "fgtvm-b"
  location                     = var.location-b
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.fgtport1-b.id, azurerm_network_interface.fgtport2-b.id]
  primary_network_interface_id = azurerm_network_interface.fgtport1-b.id
  vm_size                      = var.size


  storage_image_reference {
    id = var.custom-b ? element(azurerm_image.custom-b.*.id, 0) : null
  }

  storage_os_disk {
    name              = "osDisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk-b"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgtvm-b"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgtvm-b.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #boot_diagnostics {
  #  enabled     = true
  #  storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  #}

  tags = {
    environment = "Terraform Demo"
  }
}


resource "azurerm_virtual_machine" "fgtvm-b" {
  count                        = var.custom-b ? 0 : 1
  name                         = "fgtvm-b"
  location                     = var.location-b
  resource_group_name          = azurerm_resource_group.myterraformgroup.name
  network_interface_ids        = [azurerm_network_interface.fgtport1-b.id, azurerm_network_interface.fgtport2-b.id]
  primary_network_interface_id = azurerm_network_interface.fgtport1-b.id
  vm_size                      = var.size
  storage_image_reference {
    publisher = var.publisher
    offer     = var.fgtoffer
    sku       = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    version   = var.fgtversion
  }

  plan {
    name      = var.license_type == "byol" ? var.fgtsku["byol"] : var.fgtsku["payg"]
    publisher = var.publisher
    product   = var.fgtoffer
  }

  storage_os_disk {
    name              = "osDisk-b"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "fgtvmdatadisk-b"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = "fgtvm-b"
    admin_username = var.adminusername
    admin_password = var.adminpassword
    custom_data    = data.template_file.fgtvm-b.rendered
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  #boot_diagnostics {
  #  enabled     = true
  #  storage_uri = azurerm_storage_account.fgtstorageaccount.primary_blob_endpoint
  #}

  tags = {
    environment = "Terraform Demo"
  }
}

data "template_file" "fgtvm-b" {
  template = file(var.bootstrap-fgtvm-b)
  vars = {
    type         = var.license_type
    license_file = var.license-b
  }
}

#--------------------------------------------------------------------------#
