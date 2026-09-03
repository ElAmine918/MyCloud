# 📖 Carnet de Bord (Journal d'Apprentissage)

Ce journal documente mon apprentissage, les choix d'architecture, et les obstacles rencontrés (et résolus) lors de la construction de mon Homelab.

---

## 📅 02 Septembre 2026 : Les Fondations, le Mesh et l'Orchestration

Aujourd'hui, j'ai posé les fondations complètes de mon infrastructure locale et l'ai connectée à mon environnement de travail (Mac).

### 🛠️ Ce qui a été accompli :
1. **Domptage du Bare-Metal (Proxmox)** :
   - Le Toshiba (Core i7, 16Go RAM) sert d'hyperviseur type 1 (Proxmox VE 9).
   - J'ai configuré `logind.conf` pour ignorer la fermeture de l'écran (`HandleLidSwitch=ignore`), transformant le PC portable en vrai serveur headless.
   - Création d'une "Golden Image" (Template 9000) avec Ubuntu 24.04 et Cloud-Init.

2. **Orchestration avec K3s** :
   - Déploiement de ma première VM (`k3s-master-01`) avec Cloud-Init pour l'injection de ma clé SSH.
   - Installation du Master Node Kubernetes (K3s). J'ai pu rapatrier le Kubeconfig sur mon Mac pour piloter le cluster sans même me connecter en SSH (`kubectl get nodes`).
   - *Architecture Decision* : J'ai alloué 4 cœurs et 4 Go de RAM à ce Master node pour garder 10 Go libres pour de futures VMs (Worker ou NAS).

3. **Le Réseau Magique (Tailscale Subnet Router)** :
   - Au lieu d'installer un VPN lourd, j'ai déployé Tailscale directement sur l'hôte Proxmox.
   - J'ai activé l'IP Forwarding dans le noyau Linux et lancé Tailscale en mode `--advertise-routes=192.168.2.0/24`.
   - *Résultat* : Depuis mon Mac, en 4G, j'accède à Proxmox et à Kubernetes de façon transparente, comme si j'étais branché en RJ45 sur ma box. Pas de redirection de ports, sécurité maximale (WireGuard).

4. **Crash-Test (Résilience)** :
   - J'ai configuré la VM pour démarrer automatiquement avec l'hyperviseur (`qm set 100 --onboot 1`).
   - J'ai lancé un `reboot` brutal du serveur. Moins de 2 minutes après, le tunnel VPN était remonté et Kubernetes répondait `Ready`. Le système est totalement autonome.

### 🚧 Obstacles et Apprentissages :
- **Oracle Cloud (Always Free)** : J'ai écrit tout le code Terraform (IaC) pour provisionner l'infrastructure réseau et calcul chez Oracle. Le réseau s'est créé en 3 secondes. Cependant, la création de l'instance Ampere (ARM) a échoué avec une erreur `500-InternalError, Out of host capacity`. Le datacenter de Montréal est physiquement saturé pour les comptes gratuits. Je mets cette partie en pause en attendant qu'Oracle libère des slots.

### 🎯 Prochaines étapes :
La répartition du travail est claire :
- **L'automatisation infra** (Ansible & Terraform pour Proxmox) sera gérée pour solidifier l'IaC.
- **Le déploiement applicatif** (Kubernetes, n8n, YAML) sera mon terrain de jeu direct.
