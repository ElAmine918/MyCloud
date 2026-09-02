locals {
  target_compartment_id = var.compartment_id != "" ? var.compartment_id : var.tenancy_ocid
}

# Récupérer les Availability Domains (AD) de la région
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Récupérer la dernière image officielle Ubuntu 24.04 ARM64
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = local.target_compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
