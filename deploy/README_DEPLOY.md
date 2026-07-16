# Guide de déploiement Web sur Raspberry Pi

Ce guide explique comment compiler, déployer et héberger l'application **D&D Character Manager** sur un Raspberry Pi (ou tout autre serveur Linux) pour qu'elle soit accessible sur votre réseau local et sur Internet.

---

## 🛠️ Prérequis sur le Raspberry Pi

Assurez-vous que Docker et Docker Compose sont installés sur votre Raspberry Pi. Si ce n'est pas le cas, vous pouvez les installer rapidement avec ces commandes sur votre Pi :

```bash
# Installer Docker
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Activer Docker au démarrage
sudo systemctl enable --now docker
```

---

## 🚀 Méthode 1 : Déploiement automatisé avec Docker (Recommandé)

Nous avons inclus un script automatisé `deploy/deploy.sh` sur votre machine de développement pour s'occuper de tout.

1. Ouvrez `deploy/deploy.sh` et modifiez les variables de configuration en haut du fichier selon vos besoins :
   - `PI_USER` : Votre nom d'utilisateur sur le Pi (ex: `pi`).
   - `PI_HOST` : L'adresse IP ou nom local de votre Pi (ex: `192.168.1.50` ou `raspberrypi.local`).
   - `PI_DIR` : Dossier de destination sur le Pi.

2. Lancez le déploiement en une seule commande depuis le dossier racine du projet sur votre Mac :
   ```bash
   ./deploy/deploy.sh
   ```

Le script va :
- Compiler l'application pour le Web (`flutter build web --release`).
- Packager le build et les configurations Docker.
- Envoyer l'archive sur le Raspberry Pi via SSH.
- Arrêter l'ancien conteneur, reconstruire l'image Docker (basée sur Nginx) et relancer l'application.
- L'application sera accessible sur **`http://<IP_DU_PI>:8080`**.

---

## 🗄️ Méthode 2 : Déploiement traditionnel sans Docker (Nginx local)

Si vous préférez installer Nginx directement sur votre Raspberry Pi :

1. Installez Nginx sur le Pi :
   ```bash
   sudo apt update
   sudo apt install nginx -y
   ```

2. Compilez l'application Web sur votre Mac :
   ```bash
   flutter build web --release
   ```

3. Transférez le contenu de `build/web` vers le Pi dans le dossier Nginx :
   ```bash
   scp -r build/web/* pi@<IP_DU_PI>:/var/www/html/
   ```

4. Configurez Nginx sur le Pi pour supporter le routage Flutter (Single Page App) en éditant `/etc/nginx/sites-available/default` :
   ```nginx
   server {
       listen 80 default_server;
       listen [::]:80 default_server;

       root /var/www/html;
       index index.html;

       server_name _;

       location / {
           try_files $uri $uri/ /index.html;
       }
   }
   ```

5. Redémarrez Nginx sur le Pi :
   ```bash
   sudo systemctl restart nginx
   ```

---

## 🌐 Rendre l'application accessible sur Internet

Pour accéder à votre application depuis l'extérieur de votre domicile, plusieurs solutions s'offrent à vous :

### Option A : Tunnel Cloudflare (Recommandé, gratuit, sans ouverture de ports)
C'est la méthode la plus sécurisée car elle ne nécessite aucune ouverture de port sur votre box internet.
1. Créez un compte gratuit sur [Cloudflare](https://cloudflare.com).
2. Installez `cloudflared` sur votre Raspberry Pi :
   ```bash
   curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
   sudo dpkg -i cloudflared.deb
   ```
3. Connectez-vous et créez un tunnel vers le port local `8080` de votre conteneur Web.

### Option B : DuckDNS + Caddy / Nginx (Gratuit, nom de domaine et SSL automatique)
Si vous souhaitez utiliser **DuckDNS** pour obtenir un nom de domaine dynamique gratuit (ex: `votre-nom.duckdns.org`), voici la procédure :

1. **Création du domaine** : Rendez-vous sur [DuckDNS.org](https://www.duckdns.org/), connectez-vous et créez un sous-domaine gratuit (ex: `mon-dnd-manager`).
2. **Mise à jour automatique de l'IP sur le Pi** :
   Créez un script sur votre Raspberry Pi pour informer DuckDNS de votre adresse IP publique si elle change :
   ```bash
   mkdir -p ~/duckdns
   nano ~/duckdns/duck.sh
   ```
   Ajoutez la ligne suivante (remplacez par votre token et domaine DuckDNS) :
   ```bash
   echo url="https://www.duckdns.org/update?domains=mon-dnd-manager&token=votre-token-ici&ip=" | curl -k -K -
   ```
   Rendez le script exécutable et ajoutez-le dans le `crontab` du Pi pour qu'il s'exécute toutes les 5 minutes :
   ```bash
   chmod 700 ~/duckdns/duck.sh
   crontab -e
   # Ajouter cette ligne à la fin :
   */5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1
   ```
3. **Ouverture des ports sur votre box internet** :
   Allez dans l'interface d'administration de votre box internet (Orange/Free/SFR/Bouygues) et configurez le transfert de ports (Port Forwarding) :
   - Rediriger le port externe **80** (HTTP) vers le port **80** ou **8080** de l'IP locale de votre Pi.
   - Rediriger le port externe **443** (HTTPS) vers le port **443** de l'IP locale de votre Pi.
4. **Caddy (Reverse Proxy SSL automatique)** :
   Installez Caddy sur votre Pi. Il obtiendra automatiquement un certificat Let's Encrypt gratuit pour votre domaine DuckDNS.
   Éditez votre `/etc/caddy/Caddyfile` :
   ```caddy
   mon-dnd-manager.duckdns.org {
       reverse_proxy localhost:8080
   }
   ```
   Puis redémarrez Caddy : `sudo systemctl restart caddy`. Votre application est désormais accessible de manière sécurisée via `https://mon-dnd-manager.duckdns.org` !

---

## 🗂️ Gestion des versions et Mises à jour via Git

Pour faciliter le suivi, le développement collaboratif et les mises à jour en production sur votre Raspberry Pi, le projet a été initialisé en tant que dépôt Git local.

### 1. Pousser le projet sur GitHub ou GitLab
Depuis votre machine de développement (votre Mac) :
1. Créez un dépôt vide (ex: `dnd_character_manager`) sur GitHub ou GitLab.
2. Associez-le et poussez le code :
   ```bash
   git remote add origin https://github.com/votre-nom/dnd_character_manager.git
   git branch -M main
   git push -u origin main
   ```

### 2. Déploiement initial sur le Raspberry Pi via Git
Sur votre Raspberry Pi, clonez directement votre dépôt privé ou public :
```bash
git clone https://github.com/votre-nom/dnd_character_manager.git /home/pi/dnd_character_manager
cd /home/pi/dnd_character_manager
```

### 3. Workflow de mise à jour simple en production
Lorsque vous faites des modifications sur votre Mac, validez-les et poussez-les sur GitHub :
```bash
git add .
git commit -m "Description de vos modifications"
git push
```

Puis, sur le Raspberry Pi, pour mettre à jour l'application en ligne, lancez simplement :
```bash
cd /home/pi/dnd_character_manager
git pull
docker compose down
docker compose up -d --build
```
Ceci va automatiquement récupérer le dernier code et reconstruire le conteneur Nginx avec la version mise à jour !

