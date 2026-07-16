#!/bin/bash

# Configuration (Change these to match your Pi credentials)
PI_USER="pi"
PI_HOST="raspberrypi.local"
PI_DIR="/home/pi/dnd_character_manager"

echo "🚀 Building Flutter Web for release..."
flutter build web --release

echo "📦 Packaging deployment files..."
# Create a temporary archive containing build/web, deploy/Dockerfile, deploy/nginx.conf, and deploy/docker-compose.yml
tar -czf deploy_package.tar.gz \
    build/web \
    deploy/Dockerfile \
    deploy/nginx.conf \
    deploy/docker-compose.yml

echo "📤 Uploading package to Raspberry Pi ($PI_HOST)..."
ssh $PI_USER@$PI_HOST "mkdir -p $PI_DIR"
scp deploy_package.tar.gz $PI_USER@$PI_HOST:$PI_DIR/

echo "🛠️ Extracting and building container on Raspberry Pi..."
ssh $PI_USER@$PI_HOST "cd $PI_DIR && tar -xzf deploy_package.tar.gz && docker compose down && docker compose up -d --build"

# Clean up local archive
rm deploy_package.tar.gz

echo "✅ Deployment completed successfully! Accessible at http://$PI_HOST:8080"
