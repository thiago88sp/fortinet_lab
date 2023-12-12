output "ResourceGroup" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "FGTPublicIP-A" {
  value = azurerm_public_ip.FGTPublicIp-a.ip_address

}

output "FGTPublicIP-B" {
  value = azurerm_public_ip.FGTPublicIp-b.ip_address

}

output "Username" {
  value = var.adminusername
}

output "Password" {
  value = var.adminpassword
}

