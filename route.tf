#--------------------------------------------------------------------------#
#  ROUTE TABLE - A (East US)                                               #
#--------------------------------------------------------------------------#
#---------------------- Route Table A -------------------------------------#
resource "azurerm_route_table" "internal-a" {
  depends_on          = [azurerm_virtual_machine.fgtvm-a]
  name                = "InternalRouteTable1-A"
  location            = var.location-a
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}
#---------------------- Route A -------------------------------------------#
resource "azurerm_route" "default-a" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.internal-a.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.fgtport2-a.private_ip_address
}
#---------------------- Route Table Association A -------------------------#
resource "azurerm_subnet_route_table_association" "internalassociate-a" {
  depends_on     = [azurerm_route_table.internal-a]
  subnet_id      = azurerm_subnet.privatesubnet-a.id
  route_table_id = azurerm_route_table.internal-a.id
}
#--------------------------------------------------------------------------#
#--------------------------------------------------------------------------#
#  ROUTE TABLE - B (West US)                                               #
#--------------------------------------------------------------------------#
#---------------------- Route Table B -------------------------------------#
resource "azurerm_route_table" "internal-b" {
  depends_on          = [azurerm_virtual_machine.fgtvm-b]
  name                = "InternalRouteTable1-B"
  location            = var.location-b
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}
#---------------------- Route B -------------------------------------------#
resource "azurerm_route" "default-b" {
  name                   = "default"
  resource_group_name    = azurerm_resource_group.myterraformgroup.name
  route_table_name       = azurerm_route_table.internal-b.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.fgtport2-b.private_ip_address
}
#---------------------- Route Table Association B -------------------------#
resource "azurerm_subnet_route_table_association" "internalassociate-b" {
  depends_on     = [azurerm_route_table.internal-b]
  subnet_id      = azurerm_subnet.privatesubnet-b.id
  route_table_id = azurerm_route_table.internal-b.id
}
#--------------------------------------------------------------------------#
