// Create Virtual Network

resource "azurerm_virtual_network" "fgtvnetwork-a" {
  name                = "fgtvnetwork-a"
  address_space       = [var.vnetcidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_subnet" "publicsubnet-a" {
  name                 = "publicSubnet-a"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-a.name
  address_prefixes     = [var.publiccidr]
}

resource "azurerm_subnet" "privatesubnet-a" {
  name                 = "privateSubnet-a"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.fgtvnetwork-a.name
  address_prefixes     = [var.privatecidr]
}


// Allocated Public IP
resource "azurerm_public_ip" "FGTPublicIp-a" {
  name                = "FGTPublicIP-a"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

  tags = {
    environment = "Terraform Demo"
  }
}

//  Network Security Group
resource "azurerm_network_security_group" "publicnetworknsg-a" {
  name                = "PublicNetworkSecurityGroup-A"
  location            = var.location
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

resource "azurerm_network_security_group" "privatenetworknsg-a" {
  name                = "PrivateNetworkSecurityGroup-a"
  location            = var.location
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

resource "azurerm_network_security_rule" "outgoing_public" {
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

resource "azurerm_network_security_rule" "outgoing_private" {
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

// FGT Network Interface port1
resource "azurerm_network_interface" "fgtport1-a" {
  name                = "fgtport1-a"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.publicsubnet-a.id
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.FGTPublicIp-a.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface" "fgtport2-a" {
  name                 = "fgtport2-a"
  location             = var.location
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.privatesubnet-a.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Terraform Demo"
  }
}
# Connect the security group to the network interfaces
resource "azurerm_network_interface_security_group_association" "port1nsg-a" {
  depends_on                = [azurerm_network_interface.fgtport1-a]
  network_interface_id      = azurerm_network_interface.fgtport1-a.id
  network_security_group_id = azurerm_network_security_group.publicnetworknsg-a.id
}

resource "azurerm_network_interface_security_group_association" "port2nsg-a" {
  depends_on                = [azurerm_network_interface.fgtport2-a]
  network_interface_id      = azurerm_network_interface.fgtport2-a.id
  network_security_group_id = azurerm_network_security_group.privatenetworknsg-a.id
}

