#!/bin/bash

# Ce script est destiné à être exécuté directement sur le Raspberry Pi.
# Il récupère les derniers fichiers du dépôt Git (contenant le build précompilé)
# et relance le conteneur Docker.

# Aller à la racine du projet (le script est dans deploy/)
cd "$(dirname "$0")/.."

echo "🔄 Récupération des dernières modifications depuis Git..."
git pull

echo "🛠️ Relance et reconstruction du conteneur Docker (sans cache)..."
docker compose -f deploy/docker-compose.yml down
docker compose -f deploy/docker-compose.yml build --no-cache
docker compose -f deploy/docker-compose.yml up -d

echo "✅ Mise à jour terminée ! L'application est disponible sur le port 8080."
