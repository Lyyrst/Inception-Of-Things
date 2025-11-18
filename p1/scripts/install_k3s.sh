#!/bin/sh
set -e

ROLE="$1"
K3S_TOKEN="my_custom_token"

apk update
apk add --no-cache curl

if [ "$ROLE" = "server" ]; then
    curl -sfL https://get.k3s.io | K3S_TOKEN="$K3S_TOKEN" sh -s - server --write-kubeconfig-mode 644 --flannel-iface=eth1

elif [ "$ROLE" = "agent" ]; then
    curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="$K3S_TOKEN" sh -
else
    exit 1
fi
