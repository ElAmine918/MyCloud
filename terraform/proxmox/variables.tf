variable "proxmox_endpoint" {
  type        = string
  description = "L'URL de l'API Proxmox (ex: https://192.168.2.100:8006/)"
  default     = "https://192.168.2.100:8006/"
}

# Le token API sera passé en variable d'environnement : PROXMOX_VE_API_TOKEN
