#!/bin/bash

# Ce script est exécuté sur votre Mac de développement.
# Il compile l'application pour le Web en intégrant vos clés Supabase
# et prépare le dossier deploy/web pour Git.

# Aller à la racine du projet
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "❌ Erreur : Fichier .env introuvable à la racine du projet."
  echo "Veuillez créer un fichier .env contenant vos clés Supabase."
  exit 1
fi

echo "🚀 Compilation de Flutter Web avec les variables d'environnement..."
flutter build web --release --dart-define-from-file=.env

echo "📦 Copie des fichiers compilés vers deploy/web..."
mkdir -p deploy/web
rm -rf deploy/web/*
cp -R build/web/* deploy/web/

echo "💾 Ajout des fichiers compilés à l'index Git..."
git add deploy/web/

echo "✅ Préparation réussie !"
echo "Vous pouvez maintenant committer et pousser vos modifications : "
echo "  git commit -m 'Build de production' && git push"
echo "Ensuite, sur votre Raspberry Pi, lancez : ./deploy/deploy.sh"
