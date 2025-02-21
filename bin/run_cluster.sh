#!/bin/bash

# Define colors
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No color


# chmod +x script 
# alias run_cluster="./bin/run_cluster.sh"

# Function to check for errors
check_error() {
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error encountered! Exiting...${NC}"
    exit 1
  fi
}

# 🛑 **STOP MINIKUBE IF ALREADY RUNNING**
echo -e "${YELLOW}Checking if Minikube is running...${NC}"
if minikube status | grep -q "Running"; then
  echo -e "${RED}Minikube is already running. Stopping it...${NC}"
  minikube stop
  check_error
  echo -e "${GREEN}Minikube stopped successfully.${NC}"
else
  echo -e "${GREEN}Minikube is not running. Proceeding...${NC}"
fi



# Start the minikube 
echo -e "${CYAN}Starting Minikube using Docker...${NC}"
minikube start --driver=docker
check_error

# Delete the namespace 
echo -e "${YELLOW}Deleting existing namespace (if exists)...${NC}"
kubectl delete namespace python-web-app-ns 
if [ $? -eq 0 ]; then
  echo -e "${GREEN}Namespace deleted successfully.${NC}"
else
  echo -e "${RED}Namespace not found or deletion failed.${NC}"
fi


# Navigate to the K8S manifest files:  
echo -e "${CYAN}Navigating to Kubernetes configuration directory...${NC}"
cd /Users/moussabaidoud/workspace/devOps/k8s/flux-pyth/k8s
check_error
echo -e "${GREEN}Successfully positioned in $(pwd).${NC}"


# Applly manifest files  
echo -e "${YELLOW}Applying Kubernetes configurations...${NC}"
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress-route.yaml
check_error


echo -e "${CYAN}Waiting for pods to be ready...${NC}"
ATTEMPTS=0
MAX_ATTEMPTS=10  # Adjust the number of retries if needed
while [[ $(kubectl get pods -n python-web-app-ns -o jsonpath="{.items[0].status.phase}") != "Running" ]]; do
  if [ $ATTEMPTS -ge $MAX_ATTEMPTS ]; then
    echo -e "${RED}Pods are still not ready after multiple attempts! Exiting...${NC}"
    exit 1
  fi
  echo -e "${YELLOW}Waiting for pods... Attempt ${ATTEMPTS}/${MAX_ATTEMPTS}${NC}"
  sleep 5  # Adjust wait time if necessary
  ((ATTEMPTS++))
done

echo -e "${GREEN}Pods are now running!${NC}"


# Check services 
echo -e "${CYAN}Checking deployed services...${NC}"
kubectl get services -n python-web-app-ns
check_error

# Port forwarding 
echo -e "${YELLOW}Forwarding port for local testing...${NC}"
kubectl port-forward service/python-web-app-service 8080:5001 -n python-web-app-ns &
sleep 3
echo -e "${GREEN}Testing the service...${NC}"
curl http://localhost:8080
check_error

# Ingress route  
echo -e "${CYAN}Configuring Ingress Route...${NC}"
MINIKUBE_IP=$(minikube ip)
echo -e "${GREEN}Minikube IP: $MINIKUBE_IP${NC}"
echo "$MINIKUBE_IP python-web-app.local" | sudo tee -a /etc/hosts
check_error

# Ingress route
echo -e "${YELLOW}Checking Ingress settings...${NC}"
kubectl get ingress -n python-web-app-ns
check_error

# Open minikub tunnel route
echo -e "${CYAN}Starting Minikube Tunnel (may require sudo)...${NC}"
sudo nohup minikube tunnel > /dev/null 2>&1 &
check_error

# Get acesss with services 
echo -e "${GREEN}Access the service via Minikube:${NC}"
minikube service python-web-app-service -n python-web-app-ns --url

# Get acesss with ingress 
echo -e "${GREEN}You can also test Ingress at: http://127.0.0.1:52175/time${NC}"
