#--------------------------------------------------------------------------#
#  NETWORK A (East US)                                                     #
#--------------------------------------------------------------------------#

#---------------------Create Virtual Network-------------------------------#

resource "azurerm_virtual_network" "fgtvnetwork-a" {
  name                = "fgtvnetwork-a"
  address_space       = [var.vnetcidr-a]
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

#--------------------------------------------------------------------------#
#  SUBNET A (East US)                                                      #
#--------------------------------------------------------------------------#

#----------------------------Public Subnet---------------------------------#

resource "azurerm_subnet" "publicsubnet-a" {
  name                 = "publicSubnet-a"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-a.name
  address_prefixes     = [var.publiccidr-a]
}

#----------------------------Private Subnet-------------------------------#

resource "azurerm_subnet" "privatesubnet-a" {
  name                 = "privateSubnet-a"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-a.name
  address_prefixes     = [var.privatecidr-a]
}

#----------------------------Public IP------------------------------------#
resource "azurerm_public_ip" "FGTPublicIp-a" {
  name                = "FGTPublicIP-a"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = "Terraform Demo"
  }
}

#--------------------------------------------------------------------------#
#  NSG - A (East US)                                                       #
#--------------------------------------------------------------------------#

#----------------------------Public NSG------------------------------------#
resource "azurerm_network_security_group" "publicnetworknsg-a" {
  name                = "PublicNetworkSecurityGroup-a"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "TCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#----------------------------Public Rule NSG-------------------------------#
resource "azurerm_network_security_rule" "outgoing_public-a" {
  name                        = "egress"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.publicnetworknsg-a.name
}

#----------------------------Private NSG-----------------------------------#
resource "azurerm_network_security_group" "privatenetworknsg-a" {
  name                = "PrivateNetworkSecurityGroup-a"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#----------------------------Private Rule NSG------------------------------#
resource "azurerm_network_security_rule" "outgoing_private-a" {
  name                        = "egress-private"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.privatenetworknsg-a.name
}

#--------------------------------------------------------------------------#
#  FGT Network Interface -A (East US)                                      #
#--------------------------------------------------------------------------#

#----------------------------port1-----------------------------------------#
resource "azurerm_network_interface" "fgtport1-a" {
  name                = "fgtport1-a"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1-a"
    subnet_id                     = azurerm_subnet.publicsubnet-a.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.FGTPublicIp-a.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}
#----------------------------port2-----------------------------------------#
resource "azurerm_network_interface" "fgtport2-a" {
  name                 = "fgtport2-a"
  location             = var.location-a
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1-a"
    subnet_id                     = azurerm_subnet.privatesubnet-a.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#--------------------------------------------------------------------------#
#  NSG Association - A (East US)                                           #
#--------------------------------------------------------------------------#

#----------------------------Public NSG Association------------------------#
resource "azurerm_network_interface_security_group_association" "port1nsg-a" {
  depends_on                = [azurerm_network_interface.fgtport1-a]
  network_interface_id      = azurerm_network_interface.fgtport1-a.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg-a.id
}

#----------------------------Private NSG Association-----------------------#

resource "azurerm_network_interface_security_group_association" "port2nsg-a" {
  depends_on                = [azurerm_network_interface.fgtport2-a]
  network_interface_id      = azurerm_network_interface.fgtport2-a.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg-a.id
}

#--------------------------------------------------------------------------#

#--------------------------------------------------------------------------#
#  NETWORK B (West US)                                                     #
#--------------------------------------------------------------------------#
#---------------------Create Virtual Network-------------------------------#

resource "azurerm_virtual_network" "fgtvnetwork-b" {
  name                = "fgtvnetwork-b"
  address_space       = [var.vnetcidr-b]
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}


#--------------------------------------------------------------------------#
#  SUBNET B (West US)                                                      #
#--------------------------------------------------------------------------#

#----------------------------Public Subnet---------------------------------#

resource "azurerm_subnet" "publicsubnet-b" {
  name                 = "publicSubnet-b"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-b.name
  address_prefixes     = [var.publiccidr-b]
}

#----------------------------Private Subnet-------------------------------#

resource "azurerm_subnet" "privatesubnet-b" {
  name                 = "privateSubnet-b"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-b.name
  address_prefixes     = [var.privatecidr-b]
}

#----------------------------Public IP------------------------------------#
resource "azurerm_public_ip" "FGTPublicIp-b" {
  name                = "FGTPublicIP-b"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = "Terraform Demo"
  }
}

#--------------------------------------------------------------------------#
#  NSG - B (West US)                                                       #
#--------------------------------------------------------------------------#

#----------------------------Public NSG------------------------------------#
resource "azurerm_network_security_group" "publicnetworknsg-b" {
  name                = "PublicNetworkSecurityGroup-b"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "TCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#----------------------------Public Rule NSG-------------------------------#
resource "azurerm_network_security_rule" "outgoing_public-b" {
  name                        = "egress"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.publicnetworknsg-b.name
}

#----------------------------Private NSG-----------------------------------#
resource "azurerm_network_security_group" "privatenetworknsg-b" {
  name                = "PrivateNetworkSecurityGroup-b"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "All"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#----------------------------Private Rule NSG------------------------------#
resource "azurerm_network_security_rule" "outgoing_private-b" {
  name                        = "egress-private"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.privatenetworknsg-b.name
}

#--------------------------------------------------------------------------#
#  FGT Network Interface -B (West US)                                      #
#--------------------------------------------------------------------------#

#----------------------------port1-----------------------------------------#
resource "azurerm_network_interface" "fgtport1-b" {
  name                = "fgtport1-b"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1-b"
    subnet_id                     = azurerm_subnet.publicsubnet-b.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.FGTPublicIp-b.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}
#----------------------------port2-----------------------------------------#
resource "azurerm_network_interface" "fgtport2-b" {
  name                 = "fgtport2-b"
  location             = var.location-b
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1-b"
    subnet_id                     = azurerm_subnet.privatesubnet-b.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

#--------------------------------------------------------------------------#
#  NSG Association - B (West US)                                           #
#--------------------------------------------------------------------------#

#----------------------------Public NSG Association------------------------#
resource "azurerm_network_interface_security_group_association" "port1nsg-b" {
  depends_on                = [azurerm_network_interface.fgtport1-b]
  network_interface_id      = azurerm_network_interface.fgtport1-b.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg-b.id
}

#----------------------------Private NSG Association-----------------------#

resource "azurerm_network_interface_security_group_association" "port2nsg-b" {
  depends_on                = [azurerm_network_interface.fgtport2-b]
  network_interface_id      = azurerm_network_interface.fgtport2-b.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg-b.id
}

#--------------------------------------------------------------------------#
