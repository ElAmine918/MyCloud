# Exemple de création automatisée du futur noeud Worker (VM 101)
resource "proxmox_virtual_environment_vm" "k3s_worker" {
  name        = "k3s-worker-01"
  description = "Noeud Worker Kubernetes géré par Terraform"
  tags        = ["k3s", "worker", "terraform"]
  node_name   = "pve" # Le nom de ton hôte Toshiba
  vm_id       = 101

  # On clone ton fameux Template 9000 (Golden Image)
  clone {
    vm_id = 9000
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  # Injection Cloud-Init : on lui force une IP statique .236
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.2.236/24"
        gateway = "192.168.2.1"
      }
    }
    user_account {
      # La clé SSH par défaut est copiée depuis le template
      keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHOgO3wE2Ym6pE3pZ13+D6H3i1jB/7F832c32M39 Amine@Mac"]
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}
