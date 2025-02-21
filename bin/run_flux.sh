#!/bin/bash

# Define colors
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No color



# chmod +x script 
# alias run_flux="./bin/run_flux.sh"


# Function to check for errors
check_error() {
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error encountered! Exiting...${NC}"
    exit 1
  fi
}

# Navigate to the K8S manifest files:  
echo -e "${CYAN}Navigating to Kubernetes configuration directory...${NC}"
cd /Users/moussabaidoud/workspace/devOps/k8s/flux-pyth/
check_error
echo -e "${GREEN}Successfully positioned in $(pwd).${NC}"



# 🛠 **INSTALL FLUX (IF NOT INSTALLED)**
echo -e "${YELLOW}Checking if Flux CLI is installed...${NC}"
if ! command -v flux &> /dev/null; then
  echo -e "${RED}Flux CLI not found! Installing Flux CLI...${NC}"
  curl -s https://fluxcd.io/install.sh | sudo bash
  check_error
  echo -e "${GREEN}Flux CLI installed successfully.${NC}"
else
  echo -e "${GREEN}Flux CLI is already installed.${NC}"
fi

# 🚀 **BOOTSTRAP FLUX**
echo -e "${CYAN}Bootstrapping Flux with GitOps repo...${NC}"
flux bootstrap github \
  --owner=Mossaaba \
  --repository=flux-pyth \
  --branch=main \
  --path=flux \
  --personal
check_error


#  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


# 🔄 **APPLY FLUX MANIFESTS**
echo -e "${YELLOW}Applying Flux manifests...${NC}"
kubectl apply -f flux/
check_error

# 🔍 **VERIFY FLUX INSTALLATION**
echo -e "${CYAN}Verifying Flux installation...${NC}"
flux check --pre
check_error

echo -e "${GREEN}Flux setup complete! GitOps is now active.${NC}"