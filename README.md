# ☁️ MyCloud — Mon Lab DevOps & Cloud (Projet Étudiant)

Salut ! 👋 Bienvenue sur mon portfolio d'infrastructure. 

Ce projet est mon "Homelab" hybride. Mon objectif est d'apprendre par la pratique le métier d'ingénieur DevOps / SRE en montant une architecture de A à Z. Je combine un vieux PC portable Toshiba chez moi avec des instances gratuites dans le Cloud. 

---

## 🛠️ Mon approche

Plutôt que d'utiliser des interfaces cliquables, j'essaie de tout coder (*Infrastructure as Code*) et de documenter mes galères et mes apprentissages.

### Ce que j'ai mis en place :

1. **Bare-Metal (Le Toshiba)** 💻 : 
   - J'ai installé l'hyperviseur Proxmox directement sur le disque dur.
   - J'ai optimisé le noyau Linux pour ignorer la fermeture du capot et j'ai créé mes propres "Templates" Ubuntu avec Cloud-Init pour automatiser la création de mes serveurs virtuels.
   - Upgrade matériel : allocation fine du CPU et de la RAM (16 Go) aux VMs.

2. **Orchestration (Kubernetes / K3s)** ☸️ :
   - J'ai installé mon propre cluster Kubernetes (K3s). 
   - J'ai piloté l'installation de mes pods (Traefik, CoreDNS) et je contrôle mon cluster depuis mon Mac perso via `kubectl`.

3. **Cloud Public (Oracle / AWS)** ☁️ :
   - J'utilise **Terraform** pour scripter mes serveurs Cloud gratuits (Oracle Ampere A1).
   - J'ai appris à gérer les quotas, les limites de capacité (ex: le pool ARM de Montréal 🇨🇦) et les règles de pare-feu réseau.

4. **Réseau Mesh (Tailscale)** 🕸️ :
   - J'ai configuré un routeur virtuel Tailscale (WireGuard) directement sur Proxmox. 
   - Résultat : Je me connecte en 4G ou depuis n'importe quel Wi-Fi, et j'ai accès à tous mes serveurs internes de manière sécurisée sans ouvrir de port sur ma box internet !

---

## 📂 Organisation du code

```text
MyCloud/
├── terraform/       # Le code qui crée les serveurs (Oracle, et AWS pour la suite)
├── k8s/             # Tous mes manifestes Kubernetes pour déployer mes apps
├── ansible/         # Pour installer automatiquement les logiciels dans les VMs
├── docs/            # Mon carnet de bord : ce que j'ai appris, mes tests et solutions
└── .github/         # L'automatisation CI/CD (GitHub Actions)
```

## 📝 Carnet de bord
Tu peux lire l'évolution de mon projet, mes choix techniques (et mes erreurs réparées) dans le dossier `docs/JOURNAL.md`.
