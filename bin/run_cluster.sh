

# 1 Run minikib start : 
minikube start --driver=docker
kubectl delete namespaces python-web-app-ns ## show message if deleted 
# 2 create a namespace , deployement, service : 
cd  /Users/moussabaidoud/workspace/devOps/k8s/flux-pyth/k8s ## show message if positioned 

kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress-route.yaml


# 4 Test the service 
kubectl get services -n python-web-app-ns
kubectl port-forward service/python-web-app-service 8080:5001 -n python-web-app-ns
curl http://localhost:8080
5 # test the ingress route 
sudo echo "$(minikube ip) python-web-app.local" | sudo tee -a /etc/hosts
kubectl get ingress -n python-web-app-ns
minikube tunnel
minikube service python-web-app-service -n python-web-app-ns
http://127.0.0.1:52175/time





flux : 
# 4 Add github token classic  config 
export GITHUB_TOKEN=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
# 5 Bootstrap flux 
flux bootstrap github \                                                                           
  --owner=Mossaaba \
  --repository=fuxRepository \
  --branch=main \
  --path=./clusters/local \
  --personal





kubectl get pods -n flux-system 
minikube service python-web-app 



http://127.0.0.1:62441/time

# 6 flux reconcile source git flux-system
flux reconcile source git flux-system 
kubectl get pods -n default 


minikube start
admin : GwLymWk8Vn4kGp5A
https://localhost/rancher