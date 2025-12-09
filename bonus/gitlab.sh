#!/usr/bin/env bash

set -e

echo "=== Ajout du repo Helm GitLab ==="
helm repo add gitlab https://charts.gitlab.io/
helm repo update

echo "=== Création du namespace GitLab ==="
kubectl create namespace gitlab || true

echo "=== Installation de GitLab ==="
helm upgrade --install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=localhost \
  --set global.hosts.externalIP="127.0.0.1" \
  --set certmanager-issuer.email="admin@example.com"

echo "=== Attente du démarrage des pods ==="
kubectl get pods -n gitlab -w
