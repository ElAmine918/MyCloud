# MyCloud — Infrastructure Hybride & DevOps

Projet personnel de conception, déploiement et gestion d'une infrastructure hybride (On-Premise / Public Cloud) automatisée par du code (IaC). L'objectif est d'appliquer les concepts fondamentaux de l'ingénierie DevOps et SRE sur une architecture distribuée.

## 🏛️ Architecture Technique

```text
                      +------------------------------------------+
                      |         GitHub (CI/CD & GitOps)          |
                      +------------------------------------------+
                                    |                |
                (Réseau Mesh chiffré via Tailscale)  |
                                    |                |
           +------------------------+                +------------------------+
           |                                                                  |
           v                                                                  v
+-----------------------------+                           +-----------------------------+
|    🏢 ON-PREMISE (Local)    |                           |      ☁️ CLOUD (Public)       |
|  Hyperviseur Proxmox VE 9   |                           |    Oracle Cloud Always Free |
+-----------------------------+                           +-----------------------------+
| • Nœud K3s (Master/Worker)  | <======= VPN Mesh ======> | • Nœud K3s (Worker ARM64)   |
| • Provisioning Cloud-Init   |                           | • Instance Ampere A1        |
| • Stockage local-path       |                           | • Provisionné par Terraform |
+-----------------------------+                           +-----------------------------+
```

## 🛠️ Stack Technologique

- **Virtualisation** : Proxmox VE (Bare-metal), Cloud-Init
- **Cloud Provider** : Oracle Cloud Infrastructure (OCI)
- **Infrastructure as Code** : Terraform
- **Orchestration** : Kubernetes (K3s)
- **Réseau & Sécurité** : Tailscale (WireGuard Subnet Routing)
- **Système d'exploitation** : Ubuntu 24.04 LTS

## 📂 Structure du Dépôt

```text
MyCloud/
├── terraform/       # Code d'infrastructure (OCI, AWS)
├── k8s/             # Manifestes Kubernetes (Déploiements, Services, Ingress)
├── ansible/         # Gestion de configuration et durcissement OS
└── docs/            # Journal de bord technique et architecture
```

## 🚀 État d'avancement

- [x] **Phase 1** : Déploiement hyperviseur local (Proxmox, Cloud-Init, réseau).
- [x] **Phase 2** : Automatisation IaC cloud (Terraform OCI).
- [x] **Phase 3** : Topologie réseau Zero-Trust (Tailscale Mesh).
- [x] **Phase 4** : Déploiement du cluster Kubernetes (K3s).
