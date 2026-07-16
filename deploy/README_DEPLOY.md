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

Pour accéder de manière sécurisée à votre application depuis l'extérieur de chez vous, plusieurs options s'offrent à vous :

### Option A : Tunnel Cloudflare (Gratuit & Sécurisé, Pas besoin d'ouvrir de ports)
C'est la méthode la plus sécurisée car elle ne nécessite aucune ouverture de port sur votre box internet.
1. Créez un compte gratuit sur [Cloudflare](https://cloudflare.com).
2. Installez `cloudflared` sur votre Raspberry Pi :
   ```bash
   curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
   sudo dpkg -i cloudflared.deb
   ```
3. Connectez-vous et créez un tunnel vers le port local `8080` de votre conteneur Web.

### Option B : Reverse Proxy avec Caddy (Certificats SSL automatiques)
Si vous redirigez les ports 80 et 443 de votre box vers votre Raspberry Pi, **Caddy** est la solution la plus simple pour gérer le HTTPS automatiquement :

1. Installez Caddy sur votre Pi.
2. Créez un fichier `Caddyfile` :
   ```caddy
   mon-domaine.duckdns.org {
       reverse_proxy localhost:8080
   }
   ```
3. Caddy obtiendra automatiquement un certificat Let's Encrypt et redirigera le trafic HTTPS sécurisé vers votre application.
