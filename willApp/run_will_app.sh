#!/usr/bin/env bash

set -e

IMAGE="wil42/playground:v2"
CONTAINER="willApp-container"

docker pull "$IMAGE"

docker rm -f "$CONTAINER" 2>/dev/null || true

docker run -d --name "$CONTAINER" "$IMAGE"

docker ps --filter "name=$CONTAINER"
