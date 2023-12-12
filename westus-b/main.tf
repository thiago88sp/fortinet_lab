// Resource Group

resource "azurerm_resource_group" "myterraformgroup" {
  name     = "terraformRSG"
  location = var.location-b

  tags = {
    environment = "Terraform Demo"
  }
}
