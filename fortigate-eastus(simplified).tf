#-----------------Configurações básicas do Terraform------------------#
terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = "1.18.1"
    }
  }
}

#-----------------Provedor FortiGate-----------------#

provider "fortios" {
  # Configuration options
  alias    = "fgtvmeastus"
  hostname = "20.185.178.238"
  username = "azureadmin"
  password = "Fortinet123#"
  insecure = "true"

}


#-----------------VPN IPSEC - Phase 1-----------------#

resource "fortios_vpnipsec_phase1interface" "phase1_eastus" {
  provider       = fortios.fgtvmeastus
  name           = "to_WestUS"
  interface      = "port1" # Outgoing Interface
  assign_ip      = "enable"
  assign_ip_from = "range"
  authmethod     = "psk"
  dhgrp          = "5"
  mode           = "main"
  psksecret      = "Fortinet123#"
  local_gw       = "0.0.0.0"
  localid_type   = "auto"
  #remote_gw      = "104.45.209.126"
  remote_gw = azurerm_public_ip.FGTPublicIp-b.ip_address
  proposal  = "aes128-sha1 aes256-sha1"
  type      = "static"

  depends_on = [azurerm_public_ip.FGTPublicIp-b]
}

#-----------------VPN IPSEC - Phase 2-----------------#

resource "fortios_vpnipsec_phase2interface" "phase2_eastus" {
  provider   = fortios.fgtvmeastus
  name       = "to_WestUS"
  phase1name = fortios_vpnipsec_phase1interface.phase1_eastus.name
  src_subnet = "10.1.1.0/24"
  dst_subnet = "10.2.1.0/24"
  proposal   = "aes128-sha1 aes256-sha1"
}

#-----------------Address and Address Group-----------------#

resource "fortios_firewall_address" "to_WestUS_local_subnet_1" {
  provider      = fortios.fgtvmeastus
  name          = "to_WestUS_local_subnet_1"
  allow_routing = "enable"
  subnet        = "10.1.1.0 255.255.255.0"
}

resource "fortios_firewall_address" "to_WestUS_remote_subnet_1" {
  provider      = fortios.fgtvmeastus
  name          = "to_WestUS_remote_subnet_1"
  allow_routing = "enable"
  subnet        = "10.2.1.0 255.255.255.0"
}

resource "fortios_firewall_addrgrp" "to_WestUS_local" {
  provider = fortios.fgtvmeastus
  name     = "to_WestUS_local"
  member {
    name = fortios_firewall_address.to_WestUS_local_subnet_1.name
  }
  comment       = "VPN: to_WestUS (Created by VPN wizard)"
  allow_routing = "enable"
}

resource "fortios_firewall_addrgrp" "to_WestUS_remote" {
  provider = fortios.fgtvmeastus
  name     = "to_WestUS_remote"
  member {
    name = fortios_firewall_address.to_WestUS_remote_subnet_1.name
  }
  comment       = "VPN: to_WestUS (Created by VPN wizard)"
  allow_routing = "enable"
}

#-----------------Firewall Policy-----------------#

resource "fortios_firewall_policy" "vpn_to_WestUS_local_0" {
  provider = fortios.fgtvmeastus
  name     = "vpn_to_WestUS_local_0"
  srcintf {
    name = "port2"
  }

  dstintf {
    name = "to_WestUS"
  }

  srcaddr {
    name = "to_WestUS_local"
  }

  dstaddr {
    name = "to_WestUS_remote"
  }

  service {
    name = "ALL"
  }

  schedule   = "always"
  action     = "accept"
  comments   = "VPN: to_WestUS (Created by VPN wizard)"
  depends_on = [fortios_vpnipsec_phase2interface.phase2_eastus, fortios_router_static.static_route_eastus]
}

resource "fortios_firewall_policy" "vpn_to_WestUS_remote_0" {
  provider = fortios.fgtvmeastus
  name     = "vpn_to_WestUS_remote_0"
  srcintf {
    name = "to_WestUS"
  }

  dstintf {
    name = "port2"
  }

  srcaddr {
    name = "to_WestUS_remote"
  }

  dstaddr {
    name = "to_WestUS_local"
  }

  service {
    name = "ALL"
  }

  schedule = "always"

  action     = "accept"
  comments   = "VPN: to_WestUS (Created by VPN wizard)"
  depends_on = [fortios_vpnipsec_phase2interface.phase2_eastus, fortios_router_static.static_route_eastus]
}

#-----------------Route Static-----------------#

resource "fortios_router_static" "static_route_eastus" {
  provider = fortios.fgtvmeastus
  dst      = "10.2.1.0 255.255.255.0"
  #gateway = "0.0.0.0"
  device     = "to_WestUS" # Outgoing Interface
  depends_on = [fortios_vpnipsec_phase2interface.phase2_eastus]
}

#----------------------------------------------#
