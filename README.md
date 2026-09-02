# ☁️ MyCloud — Homelab & Multi-Cloud Hybrid Infrastructure

Portfolio d'infrastructure hybride combinant virtualisation bare-metal locale (Proxmox VE sur Toshiba) et cloud public permanent (Oracle Cloud Always Free & AWS), orchestré comme du code (IaC, GitOps, CI/CD).

---

## 🏛️ Architecture Globale

```
                      +------------------------------------------+
                      |         GitHub (CI/CD & GitOps)          |
                      |   - GitHub Actions (Terraform / Ansible) |
                      |   - DevSecOps (Checkov / tfsec)          |
                      +------------------------------------------+
                                    |                |
                (WireGuard mesh via Tailscale)       |
                                    |                |
           +------------------------+                +------------------------+
           |                                                                  |
           v                                                                  v
+-----------------------------+                           +-----------------------------+
|    🏢 LOCAL (Bare Metal)    |                           |      ☁️ CLOUD (Public)       |
|  Toshiba Laptop (PVE 9.x)   |                           |    Oracle Cloud Always Free |
+-----------------------------+                           +-----------------------------+
| • K3s Local Control/Worker  | <======= Mesh VPN ======> | • K3s Cloud Worker (Ampere) |
| • Prometheus & Grafana      |      (Tailscale / MTU     | • Public Ingress / Cloudflare|
| • local-path-provisioner    |        optimisé)          | • Terraform Provisioned     |
| • Réseau Pentest isolé      |                           |                             |
|   (Kali + Target VMs)       |                           |                             |
+-----------------------------+                           +-----------------------------+
```

---

## 📂 Structure du Répertoire

```text
MyCloud/
├── terraform/               # Infrastructure as Code (IaC)
│   ├── oci/                 # Ressources Oracle Cloud (Instances Ampere, VCN, Security Lists)
│   ├── aws/                 # Pratique AWS Free Tier (VPC, IAM, S3, Lambda)
│   └── modules/             # Modules Terraform réutilisables
├── ansible/                 # Gestion de configuration & durcissement
│   ├── inventories/         # Inventaires local / cloud / hybrid
│   ├── playbooks/           # Playbooks de configuration et durcissement OS
│   └── roles/               # Rôles Ansible (k3s, tailscale, docker, base)
├── k8s/                     # Manifests Kubernetes & Helm Charts
│   ├── base/                # Déploiements de base du cluster
│   └── apps/                # Monitoring (Prometheus/Grafana), Ingress, Services
├── docs/                    # Documentation technique & Décisions d'architecture (ADR)
│   ├── architecture/        # Schémas et explications de conception
│   └── runbooks/            # Guides opérationnels et dépannage
└── .github/workflows/       # Pipelines CI/CD pour validation IaC et déploiements
```

---

## 🚀 Phases de Déploiement

- [x] **Phase 1 : Fondation Proxmox** (Bare-metal PVE 9, sources no-subscription, lid switch, Cloud-Init templates)
- [ ] **Phase 2 : Infrastructure as Code** (Terraform OCI Always Free Ampere A1 4 OCPU / 24 GB)
- [ ] **Phase 3 : Configuration Management** (Ansible hardening, packages, configuration système)
- [ ] **Phase 4 : Réseau Mesh Hybride** (Tailscale mesh VPN entre Toshiba et Oracle Cloud)
- [ ] **Phase 5 : CI/CD & DevSecOps** (GitHub Actions + Checkov/tfsec)
- [ ] **Phase 6 : Monitoring & Observabilité** (Prometheus & Grafana avec stockage local-path)
- [ ] **Phase 7 : Lab Cybersécurité / Pentest** (VLAN/bridge isolé, Kali, DVWA)
- [ ] **Phase 8 : Architecture Decision Records (ADR) & Portfolio**
