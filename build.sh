#!/bin/bash

# Usage
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "" ]] ; then
  echo
  echo "Usage:"
  echo "$0 <tag>     # image tag (e.g., v1.4)"
  echo
  exit 1
else
  export IMAGE_TAG=$1
fi

REG_PORT=50000

echo "=== 1. Generating Kubernetes Deployment Manifest ==="
# Fix: Read from a template (.tmpl.yaml) and output to the actual manifest (.yaml)
envsubst < app/argo-app-go-server-deploy.tmpl.yaml > app/argo-app-go-server-deploy.yaml

echo "=== 2. Building Docker Image ==="
docker build -t argo-app-go-server:${IMAGE_TAG} .

echo "=== 3. Tagging Image ==="
docker tag argo-app-go-server:${IMAGE_TAG} "localhost:${REG_PORT}/argo-app-go-server:${IMAGE_TAG}"

echo "=== 4. Pushing Image to Local Registry ==="
docker push "localhost:${REG_PORT}/argo-app-go-server:${IMAGE_TAG}"

echo "=== 5. Creating Argo CD Application ==="
kubectl apply -f app/argo-app-go-server-app.yaml
