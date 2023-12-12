// Resource Group

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "terraformRSGFortigate"
  location = var.location-a

  tags = {
    environment = "Terraform Demo"
  }
}
