# 📋 Document de Handover Technique — Projet MyCloud

**Date :** 02 Septembre 2026  
**Auteur / Contexte :** Initialisation Homelab & Infrastructure Hybride  
**Statut global :** Socle Proxmox opérationnel, Git initialisé, prêt pour la phase IaC & Cloud-Init  

---

## 1. Vue d'Ensemble & Objectifs

Le projet **MyCloud** vise à déployer une infrastructure hybride (Local Bare-Metal + Cloud Public) documentée et maintenue selon les standards DevOps / SRE modernes :
- **Local :** Hyperviseur Proxmox VE hébergé sur laptop physique (Toshiba).
- **Cloud :** Ressources Always Free sur **Oracle Cloud Infrastructure (OCI)** (Ampere ARM A1, 4 vCPUs / 24 Go RAM).
- **Réseau maillé (SD-WAN / Mesh) :** Connexion sécurisée inter-sites via **Tailscale / WireGuard**.
- **Orchestration & Apps :** Cluster Kubernetes léger (**K3s**) multi-nœuds, observabilité (**Prometheus & Grafana**), lab pentest isolé (VLAN Kali/DVWA).
- **Principes fondamentaux :** 100 % Infrastructure as Code (Terraform), Gestion de Configuration (Ansible), GitOps, et zéro fuite de secrets.

---

## 2. État Actuel des Composants

### A. Nœud Hyperviseur Local (Toshiba)

| Paramètre | Valeur / État | Détails |
| :--- | :--- | :--- |
| **Machine hôte** | PC Portable Toshiba | Fonctionne comme serveur 24/7 |
| **Hyperviseur** | Proxmox Virtual Environment (PVE) **9.2.2** | Installé en bare-metal |
| **OS sous-jacent** | Debian GNU/Linux 13 (**Trixie**) | Noyau Linux moderne |
| **Adresse IP Locale** | `192.168.2.100` | Statique sur le réseau local |
| **Interface Web** | `https://192.168.2.100:8006` | Accessible et opérationnelle |
| **Gestion du capot (Lid)** | `HandleLidSwitch=ignore` | Configuré dans `/etc/systemd/logind.conf` (aucune mise en veille si l'écran est rabattu) |
| **Accès SSH** | Configuré par clé publique | Authentification par clé sans mot de passe testée et validée depuis le poste client (`ssh pve`) |

#### Configuration APT & Dépôts Proxmox (Résolue)
- **Format utilisé :** Format standard Debian deb822 (`.sources`).
- **Dépôt Entreprise PVE :** Désactivé (`/etc/apt/sources.list.d/pve-enterprise.sources` $\rightarrow$ `Enabled: false`).
- **Dépôt Entreprise Ceph :** Désactivé (`/etc/apt/sources.list.d/ceph.sources` $\rightarrow$ `Enabled: false`).
- **Dépôt No-Subscription (Gratuit) :** Activé (`/etc/apt/sources.list.d/pve-no-subscription.sources` pointant sur `http://download.proxmox.com/debian/pve`, suite `trixie`, composant `pve-no-subscription`).
- **Mises à jour système :** `apt-get dist-upgrade` exécuté avec succès $\rightarrow$ *System is up-to-date*.
- **Indicateur Web GUI :** Statut APT en warning standard (*"The no-subscription repository is not recommended for production use!"*), confirmant la réception normale des paquets communautaires.

---

### B. Poste de Gestion / Client (Macbook)

| Paramètre | Valeur / État |
| :--- | :--- |
| **Emplacement du code** | `/Users/amine/Code/MyCloud` |
| **Versionning** | Dépôt Git local initialisé sur la branche `main` |
| **Commit initial** | `a11801e` (*feat: initial homelab skeleton with IaC, Ansible, K8s, and docs structure*) |
| **Sécurité `.gitignore`** | En place (exclusions strictes : `.tfstate`, `*.tfvars`, `*.pem`, `*.key`, `*kubeconfig*`, logs, caches) |
| **Gestionnaire de paquets** | Homebrew opérationnel (`/opt/homebrew/bin/brew`) |
| **Outils CLI à installer** | `terraform`, `ansible`, `oci-cli` |

#### Structure du Répertoire Projet
```text
MyCloud/
├── .gitignore               # Protection contre fuites d'identifiants et états
├── README.md                # Description, schémas d'architecture et roadmap
├── terraform/               # IaC
│   ├── oci/                 # Déploiement Oracle Cloud Always Free
│   ├── aws/                 # Déploiement AWS Free Tier
│   └── modules/             # Modules réutilisables (VCN, Compute, etc.)
├── ansible/                 # Configuration & Hardening
│   ├── inventories/         # Hôtes locaux et cloud
│   ├── playbooks/           # Recettes d'automatisation
│   └── roles/               # Rôles système, docker, k3s, tailscale
├── k8s/                     # Manifestes Kubernetes
│   ├── base/                # Configurations socle K3s
│   └── apps/                # Monitoring (Prometheus/Grafana), ingress
├── docs/                    # Architecture Decision Records & Documentation
│   ├── architecture/        # Spécifications de conception
│   ├── runbooks/            # Procédures opérationnelles
│   └── security/            # Politiques d'isolation et pentest
└── .github/workflows/       # CI/CD (validation Terraform, Checkov, Ansible-lint)
```

---

### C. Environnement Cloud Public (Oracle OCI)

- **Compte :** Compte Oracle Cloud Always Free créé.
- **Ressources cibles à provisionner :**
  - Architecture ARM Ampere A1 (jusqu'à 4 OCPUs, 24 Go RAM gratuits à vie).
  - VCN (Virtual Cloud Network), sous-réseau public, Internet Gateway, Security Lists.
- **Statut d'intégration :** En attente de création des clés API OCI et de l'initialisation du provider Terraform.

---

## 3. Matrice des Décisions d'Architecture (ADR)

| Sujet | Décision | Justification technique |
| :--- | :--- | :--- |
| **Distribution Proxmox** | PVE 9.2.2 sur Debian 13 (Trixie) | Dernière version disponible, support matériel moderne, stack Ceph Squid / deb822. |
| **Dépôts Proxmox** | No-Subscription Repository | Évite les blocages d'authentification 401 sur les dépôts d'entreprise payants. |
| **Gestion Matérielle Laptop** | Désactivation veille capot (`logind`) | Garantit la disponibilité du serveur Proxmox écran fermé sans surchauffe ni mise en veille intempestive. |
| **Gestion des VMs** | Cloud-Init au lieu de ISO manuelles | Reproductibilité DevOps, instanciation en 10 secondes, injection automatique de clés SSH et IP. |
| **Réseau Hybride** | Tailscale (WireGuard mesh) | Pas besoin d'ouvrir des ports sur la box Internet résidentielle, gestion automatique NAT traversal. |
| **Stockage K8s** | `local-path-provisioner` | Pas de réplication de stockage synchrone (comme Ceph/Longhorn) à travers Internet en raison de la latence WAN. |

---

## 4. Feuille de Route / Prochaines Étapes Immédiates

```
[Phase 1: Local]               [Phase 2: Cloud]              [Phase 3: Hybride]
  Proxmox Setup                 Install CLI (Mac)             Tailscale Mesh
        │                               │                            │
        ▼                               ▼                            ▼
Cloud-Init Template             OCI API Keys Setup            Join K3s Nodes
    (Ubuntu/Debian)                     │                            │
        │                               ▼                            ▼
        ▼                        Terraform OCI Apply          Prometheus / Grafana
2x VMs Locales (K3s)           (Ampere A1 4 OCPU/24GB)        (Local storage pinned)
```

### Action Immédiate #1 : Création du Template Cloud-Init Proxmox (Local)
- Télécharger l'image Cloud officielle (`noble-server-cloudimg-amd64.img` ou `bookworm`).
- Créer la VM Template ID `9000` via `qm create` / `qm importdisk`.
- Configurer les paramètres Cloud-Init (clé SSH injectée, utilisateur par défaut, agent QEMU).
- Transformer la VM en template (`qm template 9000`).

### Action Immédiate #2 : Outillage du Poste Client (Mac)
- Exécuter l'installation des outils via Homebrew :
  ```bash
  brew install terraform ansible
  ```

### Action Immédiate #3 : Setup OCI & Premier Déploiement Terraform
- Générer la paire de clés RSA pour l'API Oracle Cloud.
- Récupérer les identifiants OCI dans la console web :
  - `tenancy_ocid`
  - `user_ocid`
  - `fingerprint`
  - `region`
- Écrire et tester le code Terraform dans `terraform/oci/` (création du VCN et de l'instance Ampere).

---

## 5. Fichiers & Références Clés

- **Dépôt Git :** `/Users/amine/Code/MyCloud`
- **Fichier de statut :** Ce document est consigné dans `docs/runbooks/HANDOVER_STATUS.md`.
- **Accès Proxmox :** `https://192.168.2.100:8006` | SSH: `ssh pve` ou `ssh root@192.168.2.100`.
