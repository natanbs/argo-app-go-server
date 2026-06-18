# Create the app image


# Usage
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "" ]] ; then
  echo
  echo "Usage:"  
  echo "$0 tag     # image tag"
  echo
  exit 1
else
  TAG=$1
fi

REG_PORT=50000

# Detect OS and architecture

echo Build image
docker build -t argo-app-go-server:${TAG} .

echo Docker tag
docker tag argo-app-go-server:${TAG} "localhost:${REG_PORT}/argo-app-go-server:${TAG}"

echo Docker push
docker push "localhost:${REG_PORT}/argo-app-go-server:${TAG}"

echo Create argo application argo-app-go-server
kubectl apply -f app/argo-app-go-server-app.yaml
