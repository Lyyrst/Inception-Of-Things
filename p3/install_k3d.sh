#!/usr/bin/env bash

set -e

echo "=== Suppression des dockers existants ==="
container_lst=`docker ps -a | grep -v CONTAINER | awk '{print $1}' | tr '\n' ' '`
echo Container list: "${container_lst}"
if [[ ! -z $container_lst ]]; then
	docker container rm -f ${container_lst}
	docker volume prune
fi

echo "=== Installation des dépendances ==="
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "=== Ajout de la clé GPG de Docker ==="
sudo rm -rf /etc/apt/keyrings/docker.gpg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "=== Ajout du dépôt Docker ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Installation de Docker ==="
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Ajout de l'utilisateur actuel au groupe docker ==="
sudo usermod -aG docker "$USER"

echo "=== Installation de k3d ==="
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "=== Vérifications ==="
docker --version
k3d --version

echo "=== Install kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "=== Install kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

echo "=== Installation terminée ==="
echo "⚠️ Déconnecte-toi / reconnecte-toi ou reboot pour appliquer le groupe docker."
