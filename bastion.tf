resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-a.name
  address_prefixes     = ["10.1.2.0/27"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastionpip"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

#----------------------------------------------------------------------------------#

resource "azurerm_subnet" "bastion-b" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-b.name
  address_prefixes     = ["10.2.2.0/27"]
}

resource "azurerm_public_ip" "bastion-b" {
  name                = "bastionpip-b"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-b" {
  name                = "bastion-b"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-b.id
    public_ip_address_id = azurerm_public_ip.bastion-b.id
  }
}
