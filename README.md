GMAO — Pipeline CI/CD complet (Terraform + GitHub Actions)
Architecture du pipeline
```
git push main
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│  JOB 0 — Validation du code                                 │
│  ├─ Compilation backend  : mvn compile                      │
│  ├─ Validation frontend  : npm install                      │
│  └─ Arrêt si le code est cassé (avant toute création AWS)   │
└────────────────────┬────────────────────────────────────────┘
                     │  needs: job0
                     ▼
┌─────────────────────────────────────────────────────────────┐
│  JOB 1 — Création / Vérification VM EC2                     │
│  ├─ Détection VM déjà active → skip Jobs 2 et 3             │
│  ├─ Destroy VMs arrêtées existantes (AWS CLI direct)        │
│  ├─ Terraform init / validate / plan / apply                │
│  ├─ Ubuntu 20.04 LTS | t2.large | key: vockey               │
│  ├─ Security Group : ports 22, 8080, 3000, 4200, 5432       │
│  └─ Export IP publique → jobs suivants                      │
└────────────────────┬────────────────────────────────────────┘
                     │  needs: job1
                     ▼  (skippé si VM déjà active)
┌─────────────────────────────────────────────────────────────┐
│  JOB 2 — Post-Installation (via SSH)                        │
│  ├─ apt update + upgrade                                    │
│  ├─ Java 11 (requis par Spring Boot)                        │
│  ├─ Maven                                                   │
│  ├─ PostgreSQL + démarrage service + création rôle ubuntu   │
│  ├─ Node.js 18 LTS + npm (via NodeSource)                   │
│  ├─ wget gmao-backend.tar.gz + frontend                     │
│  ├─ tar xf (décompression)                                  │
│  └─ npm install (dépendances frontend)                      │
└────────────────────┬────────────────────────────────────────┘
                     │  needs: job1, job2
                     ▼  (skippé si VM déjà active)
┌─────────────────────────────────────────────────────────────┐
│  JOB 3 — Démarrage Application (via SSH)                    │
│  ├─ restore.sh gmao_backup_20260324_1458.sql                │
│  ├─ mvn spring-boot:run  (port 8080, background)            │
│  ├─ npm start --disable-host-check (port 4200, background)  │
│  ├─ Test connectivité backend  (port 8080)                  │
│  └─ Test connectivité frontend (port 4200)                  │
└────────────────────┬────────────────────────────────────────┘
                     │  always()
                     ▼
┌─────────────────────────────────────────────────────────────┐
│  JOB FINAL — Notification & Résumé                         │
│  ├─ Rapport complet dans les logs GitHub Actions            │
│  ├─ Statut de chaque job (succès / échec / skippé)          │
│  ├─ URLs Backend, Frontend, SSH                             │
│  └─ Envoi email (succès ET échec) via Gmail SMTP            │
│     ├─ oumaimabennejma05@gmail.com                          │
│     └─ amelmradmm@gmail.com                                 │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  JOB 4 — Terraform Destroy (manuel uniquement)             │
│  ├─ Déclenché via workflow_dispatch → destroy_infra = true  │
│  └─ Supprime EC2 + Security Group                           │
└─────────────────────────────────────────────────────────────┘
```
---
Structure des fichiers
```
gmao-pipeline/
├── .github/
│   └── workflows/
│       └── deploy.yml          ← Pipeline GitHub Actions (5 jobs)
├── terraform/
│   ├── main.tf                 ← EC2 + Security Group AWS
│   ├── variables.tf            ← Région, type instance, key_name
│   └── outputs.tf              ← IP publique, instance_id
├── scripts/
│   ├── 02_post_install.sh      ← Java, Maven, PostgreSQL, Node, projets
│   └── 03_start_app.sh         ← Restore DB + Spring Boot + Angular
└── README.md
```
---
Logique du pipeline
Situation	Comportement
Aucune VM existante	Job 0 → Job 1 crée la VM → Job 2 → Job 3 → Notification
VM déjà active (running)	Job 0 → Job 1 détecte la VM → Jobs 2 et 3 skippés → Notification
VM arrêtée existante	Job 0 → Job 1 la supprime via AWS CLI → crée une nouvelle VM → Job 2 → Job 3 → Notification
Destroy manuel	Seul le Job 4 s'exécute → supprime EC2 + Security Group
---
Configuration
1. Créer le dépôt GitHub
```bash
git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com/TON_USER/gmao-pipeline.git
git push -u origin main
```
2. Ajouter les GitHub Secrets
Va dans ton repo → Settings → Secrets and variables → Actions → New repository secret
Nom du secret	Valeur
`AWS_ACCESS_KEY_ID`	Depuis AWS Academy → AWS Details
`AWS_SECRET_ACCESS_KEY`	Depuis AWS Academy → AWS Details
`AWS_SESSION_TOKEN`	Depuis AWS Academy → AWS Details
`SSH_PRIVATE_KEY`	Contenu complet du fichier `labsuser.pem`
`GMAIL_USER`	oumaimabennejma05@gmail.com
`GMAIL_PASSWORD`	Mot de passe d'application Gmail (16 chars)
> ⚠️ `SSH_PRIVATE_KEY` doit inclure les lignes `-----BEGIN RSA PRIVATE KEY-----` et `-----END RSA PRIVATE KEY-----`
3. Générer le mot de passe d'application Gmail
Va sur myaccount.google.com → Sécurité
Active la Validation en 2 étapes (si pas encore fait)
Clique Mots de passe des applications
Choisis Autre → tape `GitHub Actions` → Générer
Copie le code de 16 caractères → colle-le dans le secret `GMAIL_PASSWORD`
4. Récupérer la clé vockey (labsuser.pem)
Dans AWS Academy :
Ouvre ton Lab → clique Start Lab → attends le rond vert
Clique AWS Details → Download PEM
Copie le contenu entier dans le secret `SSH_PRIVATE_KEY`
5. Lancer le pipeline
```bash
git push origin main
# OU depuis GitHub → Actions → "GMAO — Deploy Pipeline" → Run workflow
```
---
Options du pipeline (workflow_dispatch)
Option	Valeurs	Description
`force_recreate_vm`	true / false	Force destroy + recréation même si une VM tourne
`skip_post_install`	true / false	Saute le Job 2 si les outils sont déjà installés
`destroy_infra`	true / false	Lance uniquement le Job 4 (destruction complète)
---
Ce qui a été ajouté par rapport à la demande initiale
Élément ajouté	Raison
JOB 0 — Validation code	Vérifie que le code compile avant de créer la VM
JOB FINAL — Notification	Rapport complet + email succès ET échec
Détection VM active	Évite de recréer une VM déjà fonctionnelle
Destroy via AWS CLI	`terraform destroy` ne connaît pas les VMs hors state
Java 11	Spring Boot en a absolument besoin
Node.js 18 via NodeSource	`apt install npm` installe Node 10, incompatible Angular
Security Group AWS	Sans ça, les ports 8080/4200 sont bloqués par défaut
Attente SSH	La VM met ~60s à démarrer avant d'accepter les connexions
Création rôle PostgreSQL	Ubuntu n'a pas de rôle `ubuntu` dans Postgres par défaut
`npm install`	Nécessaire avant `npm start` si `node_modules` est absent
Tests de connectivité	Vérifie que les apps répondent vraiment après démarrage
---
Commandes utiles sur la VM
```bash
# Connexion SSH
ssh -i ~/.ssh/labsuser.pem ubuntu@<PUBLIC_IP>

# Logs en temps réel
tail -f ~/backend.log
tail -f ~/frontend.log
tail -f /var/log/cloud-init-output.log

# Statut PostgreSQL
sudo systemctl status postgresql

# Arrêter les applications
pkill -f "spring-boot:run"
pkill -f "npm start"
```
---
Notes importantes
Les credentials AWS Academy expirent toutes les 4h → mets à jour les 3 secrets AWS avant chaque session
Le pipeline complet dure environ 10-15 minutes (Maven télécharge beaucoup de dépendances)
Si `terraform apply` échoue avec `key pair not found`, vérifie que `vockey` existe bien dans ta région AWS (`us-east-1`)
Le Job FINAL s'exécute toujours (`if: always()`) même si un job précédent échoue, pour garantir la notification
Les emails sont envoyés via Gmail SMTP (port 587) avec `msmtp`