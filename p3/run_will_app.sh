#!/usr/bin/env bash

set -e

IMAGE="wil42/playground:v1"
CONTAINER="playground-container"

echo "=== Pull de l'image ==="
docker pull "$IMAGE"

echo "=== Suppression d'un ancien conteneur portant le même nom (si existe) ==="
docker rm -f "$CONTAINER" 2>/dev/null || true

echo "=== Démarrage du conteneur ==="
docker run -d -p 8888:8888 --name "$CONTAINER" "$IMAGE"

echo "=== Conteneur lancé ==="
docker ps --filter "name=$CONTAINER"
