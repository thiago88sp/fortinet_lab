# Provedor FortiGate
provider "fortios" {
  # Configuration options
  alias    = "fgtvmwestus"
  hostname = "104.45.209.126"
  username = "azureadmin"
  password = "Fortinet123#"
  insecure = "true"

}


# VPN IPSEC - Phase 1
resource "fortios_vpnipsec_phase1interface" "phase1_westus" {
  provider       = fortios.fgtvmwestus
  name           = "to_EastUS"
  interface      = "port1" # Outgoing Interface
  assign_ip      = "enable"
  assign_ip_from = "range"
  authmethod     = "psk"
  dhgrp          = "5"
  mode           = "main"
  psksecret      = "Fortinet123#"
  local_gw       = "0.0.0.0"
  localid_type   = "auto"
  #remote_gw      = "20.185.178.238"
  remote_gw = azurerm_public_ip.FGTPublicIp-a.ip_address
  proposal  = "aes128-sha1 aes256-sha1"
  type      = "static"

  depends_on = [azurerm_public_ip.FGTPublicIp-a]
}

# VPN IPSEC - Phase 2
resource "fortios_vpnipsec_phase2interface" "phase2_westus" {
  provider   = fortios.fgtvmwestus
  name       = "to_EastUS"
  phase1name = fortios_vpnipsec_phase1interface.phase1_westus.name
  src_subnet = "10.2.1.0/24"
  dst_subnet = "10.1.1.0/24"
  proposal   = "aes128-sha1 aes256-sha1"
}


#Address and Address Group
resource "fortios_firewall_address" "to_EastUS_local_subnet_1" {
  provider      = fortios.fgtvmwestus
  name          = "to_EastUS_local_subnet_1"
  allow_routing = "enable"
  subnet        = "10.2.1.0 255.255.255.0"
}

resource "fortios_firewall_address" "to_EastUS_remote_subnet_1" {
  provider      = fortios.fgtvmwestus
  name          = "to_EastUS_remote_subnet_1"
  allow_routing = "enable"
  subnet        = "10.1.1.0 255.255.255.0"
}

resource "fortios_firewall_addrgrp" "to_EastUS_local" {
  provider = fortios.fgtvmwestus
  name     = "to_EastUS_local"
  member {
    name = fortios_firewall_address.to_EastUS_local_subnet_1.name
  }
  comment       = "VPN: to_EastUS (Created by VPN wizard)"
  allow_routing = "enable"
}

resource "fortios_firewall_addrgrp" "to_EastUS_remote" {
  provider = fortios.fgtvmwestus
  name     = "to_EastUS_remote"
  member {
    name = fortios_firewall_address.to_EastUS_remote_subnet_1.name
  }
  comment       = "VPN: to_EastUS (Created by VPN wizard)"
  allow_routing = "enable"
}


# Firewall Policy
resource "fortios_firewall_policy" "vpn_to_EastUS_local_0" {
  provider = fortios.fgtvmwestus
  name     = "vpn_to_EastUS_local_0"
  srcintf {
    name = "port2"
  }

  dstintf {
    name = "to_EastUS"
  }

  srcaddr {
    name = "to_EastUS_local"
  }

  dstaddr {
    name = "to_EastUS_remote"
  }

  service {
    name = "ALL"
  }

  schedule   = "always"
  action     = "accept"
  comments   = "VPN: to_EastUS (Created by VPN wizard)"
  depends_on = [fortios_vpnipsec_phase2interface.phase2_westus, fortios_router_static.static_route_westus]
}

resource "fortios_firewall_policy" "vpn_to_EastUS_remote_0" {
  provider = fortios.fgtvmwestus
  name     = "vpn_to_EastUS_remote_0"
  srcintf {
    name = "to_EastUS"
  }

  dstintf {
    name = "port2"
  }

  srcaddr {
    name = "to_EastUS_remote"
  }

  dstaddr {
    name = "to_EastUS_local"
  }

  service {
    name = "ALL"
  }

  schedule = "always"

  action     = "accept"
  comments   = "VPN: to_EastUS (Created by VPN wizard)"
  depends_on = [fortios_vpnipsec_phase2interface.phase2_westus, fortios_router_static.static_route_westus]
}



# Route Static
resource "fortios_router_static" "static_route_westus" {
  provider = fortios.fgtvmwestus
  dst      = "10.1.1.0 255.255.255.0"
  #gateway = "0.0.0.0"
  device     = "to_EastUS" # Outgoing Interface
  depends_on = [fortios_vpnipsec_phase2interface.phase2_westus]
}
