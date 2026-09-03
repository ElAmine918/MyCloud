variable "tenancy_ocid" {
  description = "OCID de la Tenancy Oracle Cloud"
  type        = string
}

variable "user_ocid" {
  description = "OCID de l'utilisateur Oracle Cloud"
  type        = string
}

variable "fingerprint" {
  description = "Empreinte (fingerprint) de la clé API publique enregistrée sur OCI"
  type        = string
}

variable "private_key_path" {
  description = "Chemin vers la clé privée RSA téléchargée depuis la console OCI"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  description = "Région OCI principale (ex: ca-montreal-1, ca-toronto-1, us-ashburn-1, eu-paris-1)"
  type        = string
}

variable "compartment_id" {
  description = "OCID du compartiment (par défaut = tenancy_ocid pour le compartiment racine Always Free)"
  type        = string
  default     = ""
}

variable "ssh_public_key_path" {
  description = "Chemin vers ta clé SSH publique locale pour te connecter à l'instance"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "instance_ocpus" {
  description = "Nombre d'OCPUs ARM Ampere A1 (Always Free autorise jusqu'à 2 OCPUs permanents, soit 1 500 h/mois)"
  type        = number
  default     = 2
}

variable "instance_memory_in_gbs" {
  description = "Quantité de mémoire vive en Go (Always Free autorise jusqu'à 12 Go permanents, soit 9 000 Go-h/mois)"
  type        = number
  default     = 12
}

variable "boot_volume_size_in_gbs" {
  description = "Taille du disque de démarrage en Go (Always Free offre 200 Go au total)"
  type        = number
  default     = 50
}
