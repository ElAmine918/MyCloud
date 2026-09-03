# 🗺️ Roadmap & Plan du Homelab

Ce document trace l'évolution de l'infrastructure, des fondations bare-metal jusqu'à l'orchestration avancée.

## ✅ Phases Complétées
- [x] **Phase 1 : Fondation Proxmox (Local)**
  - Installation Proxmox VE 9 sur Toshiba P50-A.
  - Configuration système (désactivation veille capot).
  - Création du Template Cloud-Init (Ubuntu 24.04).
  - Déploiement de la VM Master (`k3s-master-01`) avec 4 cœurs / 4 Go RAM.
- [x] **Phase 3 : Réseau Hybride Zero-Trust**
  - Installation de Tailscale sur l'hôte Proxmox.
  - Activation du mode `Subnet Router` (192.168.2.0/24).
  - Pilotage transparent depuis le Mac en 4G/Extérieur.
- [x] **Phase 4 : Kubernetes (Control Plane)**
  - Déploiement de K3s (Master) sur la VM locale.
  - Configuration de `kubectl` sur le Mac.
  - Validation de la résilience au redémarrage physique (Crash-test réussi).

## ⏳ Phases En Attente (Facteurs Externes)
- [ ] **Phase 2 : Infrastructure as Code (Oracle Cloud)**
  - *Statut* : Code Terraform écrit et testé. Réseau Cloud déployé.
  - *Blocage* : Capacité ARM Ampere saturée sur la région Montréal (Error 500 Out of host capacity). En attente de libération de ressources.

## 🚀 Phases En Cours (Prochaines Étapes)

- [ ] **Phase 1.5 (Option B) : Automatisation Proxmox via Terraform**
  - Objectif : Remplacer la création manuelle de VMs (`qm clone`) par du code Terraform.
  - Tâches : Configuration du provider `bpg/proxmox`, création des tokens API, écriture du code pour provisionner un noeud Worker ou un NAS.

- [ ] **Phase 5 (Option C) : Gestion de Configuration (Ansible)**
  - Objectif : Maintenir l'OS des VMs à jour et sécurisé sans intervention manuelle.
  - Tâches : Création de l'inventaire dynamique/statique, playbooks de durcissement (SSH, pare-feu, mises à jour auto).

- [ ] **Phase 6 (Option A - Autonome) : Déploiements Kubernetes (Workloads)**
  - Objectif : Déployer des applications réelles (n8n, monitoring, services) via des manifestes K8s (YAML/Helm).
