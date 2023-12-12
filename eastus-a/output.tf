output "ResourceGroup" {
  value = azurerm_resource_group.myterraformgroup.name
}

output "FGTPublicIP" {
  value = azurerm_public_ip.FGTPublicIp-a.ip_address

}

output "Username" {
  value = var.adminusername
}

output "Password" {
  value = var.adminpassword
}

