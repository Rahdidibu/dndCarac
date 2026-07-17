#!/bin/bash

# Lancement de l'application en local sur Google Chrome avec les variables d'environnement.

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "❌ Erreur : Fichier .env introuvable."
  echo "Veuillez créer un fichier .env contenant vos clés Supabase."
  exit 1
fi

echo "🚀 Lancement de l'application en local sur Google Chrome..."
flutter run -d chrome --dart-define-from-file=.env
