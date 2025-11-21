#!/usr/bin/env bash

set -e

echo "=== Mets le reload argo cd a 60 secondes ===
kubectl -n argocd patch configmap argocd-cm --type merge  -p '{"data":{"repository.refresh": "60s"}}'"

echo "=== Création du cluster k3d ==="
k3d cluster create bonuscluster -p "80:80@loadbalancer" -p "443:443@loadbalancer" || echo "Cluster déjà existant"

echo "=== Vérification du cluster ==="
kubectl get nodes

echo "=== Création des namespaces ==="
kubectl create namespace argocd || echo "Namespace argocd deja cree"
kubectl create namespace dev || echo "Namespace dev deja cree"
kubectl create namespace gitlab || echo "Namespace gitlab deja cree"

echo "=== Installation d'ArgoCD ==="
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "=== Attente des pods ArgoCD ==="
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=180s || true

echo "=== Exposition du serveur ArgoCD ==="
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

echo "=== Récupération du mot de passe admin ==="
echo "Mot de passe admin ArgoCD :"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""

LB_PORT=$(kubectl get svc -n argocd argocd-server -o jsonpath='{.spec.ports[0].nodePort}')

echo "=== URL ArgoCD ==="
echo "ArgoCD UI : http://localhost:${LB_PORT}"
echo "Identifiant : admin"

echo "=== Le cluster est prêt, sync avec github repo ==="
kubectl apply -f argocd-app.yaml

echo "=== Verifie que l'application est creee ==="
kubectl get applications -n argocd
