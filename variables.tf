// Azure configuration
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "size" {
  type    = string
  default = "Standard_F4"
}

// To use custom image
// by default is false
variable "custom-a" {
  default = false
}

//  Custom image blob uri
variable "customuri" {
  type    = string
  default = "<custom image blob uri>"
}

variable "custom_image_name" {
  type    = string
  default = "<custom image name>"
}

variable "custom_image_resource_group_name" {
  type    = string
  default = "<custom image resource group>"
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
}

variable "publisher" {
  type    = string
  default = "fortinet"
}

variable "fgtoffer" {
  type    = string
  default = "fortinet_fortigate-vm_v5"
}

// BYOL sku: fortinet_fg-vm
// PAYG sku: fortinet_fg-vm_payg_20190624
variable "fgtsku" {
  type = map(any)
  default = {
    byol = "fortinet_fg-vm"
    payg = "fortinet_fg-vm_payg_2022"
  }
}

variable "fgtversion" {
  type    = string
  default = "7.0.12"
}

variable "adminusername" {
  type    = string
  default = "azureadmin"
}

variable "adminpassword" {
  type    = string
  default = "Fortinet123#"
}

variable "location-a" {
  type    = string
  default = "eastus"
}

variable "vnetcidr-a" {
  default = "10.1.0.0/16"
}

variable "publiccidr-a" {
  default = "10.1.0.0/24"
}

variable "privatecidr-a" {
  default = "10.1.1.0/24"
}

variable "bootstrap-fgtvm-a" {
  // Change to your own path
  type    = string
  default = "fgtvm-a.conf"
}

// license file for the fgt
variable "license-a" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licensea.txt"
}

variable "prefix-a" {
  description = "The prefix which should be used for all resources in this example"
  default     = "vm"
}


#--------------------------------------------------------------------------#
#  Variables - B (West US)                                                 #
#--------------------------------------------------------------------------#

// To use custom image
// by default is false
variable "custom-b" {
  default = false
}

variable "location-b" {
  type    = string
  default = "westus"
}

variable "vnetcidr-b" {
  default = "10.2.0.0/16"
}

variable "publiccidr-b" {
  default = "10.2.0.0/24"
}

variable "privatecidr-b" {
  default = "10.2.1.0/24"
}

variable "bootstrap-fgtvm-b" {
  // Change to your own path
  type    = string
  default = "fgtvm-b.conf"
}

// license file for the fgt
variable "license-b" {
  // Change to your own byol license file, license.lic
  type    = string
  default = "./licenseb.txt"
}

variable "prefix-b" {
  description = "The prefix which should be used for all resources in this example"
  default     = "vm"
}
