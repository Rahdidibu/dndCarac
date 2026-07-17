#!/bin/bash

# Ce script compile l'application pour Android (APK) et pour le Web,
# puis copie l'APK dans le build Web afin de le rendre téléchargeable,
# et enfin prépare le dossier deploy/web pour Git.

# Aller à la racine du projet
cd "$(dirname "$0")/.."

if [ ! -f .env ]; then
  echo "❌ Erreur : Fichier .env introuvable à la racine du projet."
  echo "Veuillez créer un fichier .env contenant vos clés Supabase."
  exit 1
fi

echo "🚀 Compilation de l'APK Android (release)..."
flutter build apk --release --dart-define-from-file=.env

echo "🚀 Compilation de Flutter Web avec les variables d'environnement..."
flutter build web --release --dart-define-from-file=.env

echo "📦 Copie des fichiers web vers deploy/web..."
mkdir -p deploy/web
rm -rf deploy/web/*
cp -R build/web/* deploy/web/

echo "📦 Copie de l'APK dans deploy/web pour le téléchargement..."
cp build/app/outputs/flutter-apk/app-release.apk deploy/web/

echo "💾 Ajout des fichiers compilés à l'index Git..."
git add deploy/web/

echo "✅ Préparation réussie !"
echo "Vous pouvez maintenant committer et pousser vos modifications : "
echo "  git commit -m 'Build de production avec APK' && git push"
echo "Ensuite, sur votre Raspberry Pi, lancez : ./deploy/deploy.sh"
