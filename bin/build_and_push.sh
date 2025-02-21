#!/bin/bash


# alias run_push_to_docker_hub="./bin/build_and_push.sh"


# Configuration
DOCKER_HUB_USERNAME="mouss1959"
IMAGE_NAME="flask-app"
VERSION="1.0.9"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_message() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

print_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if user is logged in to Docker Hub
if ! docker info | grep -q "Username"; then
    print_warning "You are not logged in to Docker Hub"
    print_message "Please log in to Docker Hub:"
    docker login
fi

# Build the Docker image
print_message "Building Docker image..."
docker build -t $IMAGE_NAME:$VERSION .

if [ $? -ne 0 ]; then
    print_error "Failed to build Docker image"
    exit 1
fi

# Tag the image
print_message "Tagging image..."
docker tag $IMAGE_NAME:$VERSION $DOCKER_HUB_USERNAME/$IMAGE_NAME:$VERSION
docker tag $IMAGE_NAME:$VERSION $DOCKER_HUB_USERNAME/$IMAGE_NAME:latest

# Push the image to Docker Hub
print_message "Pushing image to Docker Hub..."
docker push $DOCKER_HUB_USERNAME/$IMAGE_NAME:$VERSION
docker push $DOCKER_HUB_USERNAME/$IMAGE_NAME:latest

if [ $? -ne 0 ]; then
    print_error "Failed to push Docker image"
    exit 1
fi

print_message "Successfully built and pushed image to Docker Hub!"
print_message "Image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:$VERSION"
print_message "Image: $DOCKER_HUB_USERNAME/$IMAGE_NAME:latest"

# Clean up
print_message "Cleaning up local images..."
docker rmi $DOCKER_HUB_USERNAME/$IMAGE_NAME:$VERSION
docker rmi $DOCKER_HUB_USERNAME/$IMAGE_NAME:latest

print_message "Done! 🚀" 