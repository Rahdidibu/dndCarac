# Guide de déploiement et de mise en service sur Raspberry Pi

Ce guide explique comment initialiser la base de données Supabase, configurer et compiler l'application sur votre machine de développement (Mac), puis la déployer et la mettre à jour sur votre Raspberry Pi en utilisant uniquement Git et Docker (sans nécessiter de connexion SSH directe depuis votre machine de développement).

---

## 🗄️ 1. Initialisation de la Base de Données (Supabase)

L'application utilise désormais **Supabase (PostgreSQL)** hébergé sur le Cloud gratuit pour stocker les données des personnages en mode multi-utilisateur.

1. Rendez-vous sur votre console [Supabase](https://supabase.com/) et créez un nouveau projet gratuit.
2. Une fois le projet prêt, allez dans le volet **SQL Editor** dans la barre latérale gauche.
3. Cliquez sur **New Query** (Nouvelle requête).
4. Copiez l'intégralité du contenu du fichier [deploy/supabase_schema.sql](file:///Users/mber/develop/dnd_character_manager/deploy/supabase_schema.sql) du projet.
5. Collez ce code SQL dans l'éditeur Supabase et cliquez sur **Run** en bas à droite.
   - *Cela va créer toutes les tables requises (D&D et Batman) et activer la sécurité au niveau des lignes (RLS) pour isoler les personnages de chaque utilisateur.*

---

## 💻 2. Configuration & Compilation (Sur votre Mac)

Puisque le Raspberry Pi 3B a des ressources limitées (1 Go de RAM), nous compilons l'application Web sur le Mac, puis nous poussons les fichiers compilés statiques sur Git. Ainsi, le Pi n'aura qu'à servir ces fichiers via un conteneur Nginx ultra-léger (qui consomme moins de 10 Mo de RAM).

1. **Configuration locale** : Créez un fichier `.env` à la racine du projet sur votre Mac et ajoutez-y vos identifiants Supabase :
   ```env
   SUPABASE_URL=https://votre-projet.supabase.co
   SUPABASE_ANON_KEY=votre-cle-anonyme-de-projet
   ```
2. **Compilation et préparation** : Exécutez le script de build depuis le terminal de votre Mac :
   ```bash
   ./deploy/build_and_prepare.sh
   ```
   Ce script va :
   - Compiler l'application Flutter Web en y intégrant vos clés Supabase (`--dart-define-from-file=.env`).
   - Copier le dossier généré vers `deploy/web/`.
   - Indexer ces fichiers compilés dans Git pour qu'ils soient prêts à être committés.
3. **Commit & Push** : Envoyez le code mis à jour sur votre dépôt Git distant (GitHub, GitLab, etc.) :
   ```bash
   git commit -m "Build de production avec Supabase"
   git push origin main
   ```

---

## 🍓 3. Déploiement & Mises à jour (Sur le Raspberry Pi)

### Déploiement initial sur le Pi
1. Connectez-vous sur votre Raspberry Pi (par exemple en ouvrant un terminal sur le Pi ou en SSH).
2. Installez Docker et Docker Compose si ce n'est pas déjà fait :
   ```bash
   curl -sSL https://get.docker.com | sh
   sudo usermod -aG docker $USER
   sudo systemctl enable --now docker
   ```
3. Clonez le dépôt Git du projet sur votre Pi :
   ```bash
   git clone <URL_DE_VOTRE_REPO_GIT> /home/pi/dnd_character_manager
   cd /home/pi/dnd_character_manager
   ```
4. Exécutez le script de déploiement pour démarrer l'application :
   ```bash
   ./deploy/deploy.sh
   ```
   *L'application sera lancée dans un conteneur Nginx et accessible sur votre réseau local à l'adresse : **`http://<IP_DU_PI>:8080`**.*

### Workflow de mise à jour simple en production
Lorsque vous faites des modifications dans le code sur votre Mac :
1. Sur votre Mac, recompilez et préparez les fichiers : `./deploy/build_and_prepare.sh`
2. Poussez sur Git : `git commit -am "Mise à jour" && git push`
3. Sur votre Raspberry Pi, lancez simplement :
   ```bash
   ./deploy/deploy.sh
   ```
   Le script va automatiquement faire un `git pull` pour récupérer la dernière version compilée et relancer le conteneur Docker Nginx à chaud en 2 secondes !

---

## 🌐 4. Rendre l'application accessible sur Internet

Pour accéder à votre gestionnaire de fiches depuis n'importe où, voici les deux méthodes recommandées :

### Option A : Tunnel Cloudflare (Gratuit, sécurisé et sans ouverture de ports)
C'est la méthode idéale car elle ne nécessite aucune configuration compliquée sur votre box internet.
1. Installez `cloudflared` sur votre Raspberry Pi :
   ```bash
   curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
   sudo dpkg -i cloudflared.deb
   ```
2. Créez un tunnel Cloudflare gratuit depuis le tableau de bord Cloudflare Zero Trust et redirigez le trafic de votre domaine personnalisé vers l'adresse locale **`http://localhost:8080`** de votre Pi.

### Option B : DuckDNS + Caddy (Gratuit, nom de domaine et SSL automatique)
Si vous préférez utiliser un sous-domaine dynamique DuckDNS :
1. Créez un sous-domaine gratuit sur [DuckDNS.org](https://www.duckdns.org/) : **`vadndim.duckdns.org`**.
2. Créez un script de mise à jour d'IP sur le Pi :
   ```bash
   mkdir -p ~/duckdns
   nano ~/duckdns/duck.sh
   ```
   Ajoutez-y la ligne suivante :
   ```bash
   echo url="https://www.duckdns.org/update?domains=vadndim&token=3bcec803-6d10-480e-b6e4-d6cee8bc89e6&ip=" | curl -k -K -
   ```
   Rendez le script exécutable et configurez-le dans le `crontab` du Pi pour se lancer toutes les 5 minutes :
   ```bash
   chmod 700 ~/duckdns/duck.sh
   crontab -e
   # Ajouter cette ligne à la fin :
   */5 * * * * ~/duckdns/duck.sh >/dev/null 2>&1
   ```
3. Configurez une redirection de port (NAT/PAT) sur l'interface d'administration de votre box internet :
   - Redirigez le port externe **80** (HTTP) vers le port **8080** de l'IP locale de votre Pi.
   - Redirigez le port externe **443** (HTTPS) vers le port **443** de l'IP locale de votre Pi.
4. Installez Caddy sur le Pi pour gérer le certificat SSL Let's Encrypt automatique. Modifiez votre `/etc/caddy/Caddyfile` :
   ```caddy
   vadndim.duckdns.org {
       reverse_proxy localhost:8080
   }
   ```
   Puis relancez Caddy : `sudo systemctl restart caddy`. Votre application est accessible en HTTPS sur `https://vadndim.duckdns.org` !

---

## 💻 5. Développement Local avec VS Code DevContainer (Optionnel)

Si vous souhaitez coder ou tester l'application localement dans le même environnement standardisé sans encombrer votre machine hôte avec des SDK Flutter/Dart ou des dépendances Java/C++ :

1. Ouvrez ce dossier de projet dans **Visual Studio Code**.
2. Installez l'extension officielle **Dev Containers** (`ms-vscode-remote.remote-containers`).
3. VS Code détectera automatiquement la configuration et vous proposera de rouvrir le dossier dans un conteneur (**"Reopen in Container"**).
4. Le conteneur se construit avec les prérequis Flutter ( stable ) et résout automatiquement le `flutter pub get`.
5. Pour lancer l'application en mode serveur web local avec rechargement à chaud (Hot Reload) depuis le conteneur :
   ```bash
   flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0 --dart-define-from-file=.env
   ```
6. Le port `8080` est automatiquement redirigé vers votre navigateur hôte (Mac) pour pouvoir tester en direct !

---

## 🗄️ 6. Base de Données Supabase en Local (Optionnel)

Pour développer complètement hors-ligne ou tester vos développements sans toucher à votre base de données Cloud de production, nous avons inclus la configuration pour faire tourner **Supabase en local** via Docker :

1. **Prérequis** : 
   - Si vous utilisez le **VS Code DevContainer**, la Supabase CLI et Docker sont **déjà pré-installés et configurés**. Passez directement à l'étape 2.
   - Si vous développez directement sur votre Mac hôte, installez la [Supabase CLI](https://supabase.com/docs/guides/cli) :
     ```bash
     brew install supabase/tap/supabase
     ```
2. **Démarrage de la base** : Ouvrez un terminal (dans VS Code ou sur votre Mac) à la racine du projet et lancez :
   ```bash
   supabase start
   ```
   *Ce script va démarrer toute la stack Supabase locale (Postgres, Auth, Studio) et exécuter automatiquement la migration de schéma SQL présente dans `supabase/migrations/`.*
3. **Récupération des clés** : Le terminal affichera vos clés d'API locales :
   - `API URL` : généralement `http://127.0.0.1:54321` (ou `http://localhost:54321`)
   - `anon key` : votre clé anonyme locale
4. **Configuration du .env** : Copiez ces valeurs dans votre fichier `.env` local pour que l'application s'y connecte au lieu du Cloud :
   ```env
   SUPABASE_URL=http://localhost:54321
   SUPABASE_ANON_KEY=votre-anon-key-locale-generee
   ```
5. **Console locale (Studio)** : Vous pouvez visualiser et éditer les données de votre base locale sur l'interface d'administration à l'adresse **`http://localhost:54323`**.
6. **Arrêter la base** : Pour libérer les ressources, lancez :
   ```bash
   supabase stop
   ```


