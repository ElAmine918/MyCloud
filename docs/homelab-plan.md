# Plan Homelab — Cloud Infra & Cybersécurité

Projet portfolio combinant infrastructure locale (Toshiba \+ Proxmox) et cloud gratuit permanent (Oracle Cloud Always Free, AWS Free Tier), documenté sur GitHub.

---

## 🖥️ Environnement local — Toshiba (Proxmox)

Tout ce qui tourne physiquement chez toi, sur le hardware que tu contrôles entièrement.

### Phase 1 — Fondation Proxmox

- Installer Proxmox VE en bare-metal sur le Toshiba  
- Monter 2-3 VMs légères  
- Déployer un premier cluster K3s (node local)

### Phase 3 (partie locale) — Configuration management

- Playbooks Ansible appliqués aux VMs du Toshiba (paquets, durcissement sécurité, déploiement d'apps)

### Phase 4 (partie locale) — Node du cluster hybride

- Client Tailscale sur le Toshiba pour connecter ce node au cluster cloud  
- Documenter les défis de latence/MTU côté local

### Phase 6 — Monitoring (hébergé localement)

- Prometheus \+ Grafana déployés sur K3s  
- **Stockage :** `local-path-provisioner` intégré à K3s, épinglé au node Toshiba via `nodeSelector`/`taint` — pas de réplication cross-WAN  
- Alternative si tu ajoutes un 2e node local plus tard : Longhorn *uniquement* entre nodes locaux (latence sub-ms), jamais en cross-site avec le cloud

### Phase 7 — Segment sécurité/pentest isolé

- Réseau virtuel Proxmox complètement séparé (aucune route vers le reste)  
- VM Kali \+ cibles vulnérables (Metasploitable, DVWA, boxes THM/HTB téléchargeables)  
- Write-ups documentés dans un repo `ctf-writeups` séparé

---

## ☁️ Environnement cloud — Oracle Cloud / AWS (gratuit, permanent)

Tout ce qui tourne sur les comptes cloud, provisionné en code plutôt qu'à la main.

### Comptes à créer

- **Oracle Cloud Always Free** — 2 vCPU ARM Ampere \+ 12GB RAM permanent (1 500 h OCPU & 9 000 Go-h/mois)  
- **AWS Free Tier** — 12 mois EC2/S3/Lambda/IAM/VPC  
- (optionnel) Azure Free Account, Google Cloud Free Tier

### Phase 2 — Infrastructure as Code

- Provisionner les instances Oracle Ampere via **Terraform** (pas la console web)  
- Versionner les fichiers `.tf` dans le repo GitHub

### Phase 3 (partie cloud) — Configuration management

- Mêmes playbooks Ansible appliqués aux instances Oracle/AWS pour garantir la cohérence avec l'environnement local

### Phase 4 (partie cloud) — Node(s) du cluster hybride

- Instance(s) Oracle Ampere comme node(s) additionnels du cluster K3s  
- Connexion via Tailscale au node Toshiba

### Pratique additionnelle AWS (hors cluster)

- IAM, VPC/networking, S3, Lambda — compétences AWS pures recherchées à l'embauche

---

## 🔗 Transversal — ne dépend pas d'un environnement spécifique

Vit dans GitHub, orchestre les deux environnements.

### Phase 5 — CI/CD avec GitHub Actions

- Pipeline déclenchée à chaque push : applique les changements Terraform/Ansible (review avant apply en prod)  
- **DevSecOps :** intégrer Checkov ou tfsec pour scanner les fichiers Terraform (failles de config) avant déploiement

### Phase 8 — Documentation finale

- README avec diagramme d'architecture (draw.io / Excalidraw)  
- Expliquer le **pourquoi** de chaque choix technique, pas juste le comment  
- Documenter explicitement les trade-offs rejetés (ex. Longhorn cross-site) — montre une compréhension réelle, pas juste un tutoriel suivi

---

## Structure de repos suggérée

homelab/                 → infra as code (Terraform, Ansible, manifests K8s, CI/CD)

ctf-writeups/             → write-ups de résolution des challenges pentest  
