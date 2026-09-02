# VCN (Virtual Cloud Network)
resource "oci_core_vcn" "homelab_vcn" {
  compartment_id = local.target_compartment_id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "mycloud-vcn"
  dns_label      = "mycloud"
}

# Passerelle Internet (Internet Gateway)
resource "oci_core_internet_gateway" "igw" {
  compartment_id = local.target_compartment_id
  vcn_id         = oci_core_vcn.homelab_vcn.id
  display_name   = "mycloud-igw"
  enabled        = true
}

# Table de routage par défaut vers Internet
resource "oci_core_default_route_table" "default_route" {
  manage_default_resource_id = oci_core_vcn.homelab_vcn.default_route_table_id
  display_name               = "mycloud-default-route"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Security List (Pare-feu réseau OCI)
resource "oci_core_security_list" "public_security_list" {
  compartment_id = local.target_compartment_id
  vcn_id         = oci_core_vcn.homelab_vcn.id
  display_name   = "mycloud-public-security-list"

  # Tout le trafic sortant est autorisé
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # Ingress : SSH (Port 22)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    stateless   = false
    description = "SSH Access"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Ingress : Kubernetes API (Port 6443) pour relier le cluster hybride
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    stateless   = false
    description = "K3s / Kubernetes API"

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # Ingress : Tailscale / WireGuard UDP
  ingress_security_rules {
    protocol    = "17" # UDP
    source      = "0.0.0.0/0"
    stateless   = false
    description = "Tailscale / WireGuard UDP Direct Connection"

    udp_options {
      min = 41641
      max = 41641
    }
  }

  # Ingress : ICMP (Ping / MTU discovery)
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "0.0.0.0/0"
    stateless   = false
    description = "ICMP Traffic"

    icmp_options {
      type = 3
      code = 4
    }
  }
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "0.0.0.0/0"
    stateless   = false
    description = "ICMP Ping"

    icmp_options {
      type = 8
    }
  }
}

# Sous-réseau public
resource "oci_core_subnet" "public_subnet" {
  compartment_id    = local.target_compartment_id
  vcn_id            = oci_core_vcn.homelab_vcn.id
  cidr_block        = "10.0.1.0/24"
  display_name      = "mycloud-public-subnet"
  dns_label         = "public"
  security_list_ids = [oci_core_security_list.public_security_list.id]
  route_table_id    = oci_core_default_route_table.default_route.id
}
