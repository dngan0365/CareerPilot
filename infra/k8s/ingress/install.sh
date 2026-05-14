echo "Installing nginx ingress controller..."
 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
 
echo "Waiting for ingress controller to be ready..."
 
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
 
echo "nginx ingress controller is ready."