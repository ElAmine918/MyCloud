output "instance_name" {
  description = "Nom de l'instance déployée"
  value       = oci_core_instance.ampere_instance.display_name
}

output "instance_public_ip" {
  description = "Adresse IP publique de l'instance Oracle Cloud Always Free"
  value       = oci_core_instance.ampere_instance.public_ip
}

output "ssh_command" {
  description = "Commande SSH pour se connecter à l'instance"
  value       = "ssh ubuntu@${oci_core_instance.ampere_instance.public_ip}"
}
