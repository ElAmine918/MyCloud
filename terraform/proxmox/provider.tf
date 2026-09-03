provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = true # Nécessaire car Proxmox utilise un certificat auto-signé par défaut
  
  # Pour l'authentification, Terraform va lire automatiquement
  # la variable d'environnement : PROXMOX_VE_API_TOKEN
}
