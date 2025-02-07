#!/bin/bash

# Configuration
CONTAINER_NAME="flask-app"
IMAGE_NAME="flask-app"
PORT=5001
ENV_FILE=".env"

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

# Stop and remove existing container if it exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    print_warning "Found existing container. Stopping and removing..."
    docker stop $CONTAINER_NAME >/dev/null 2>&1
    docker rm $CONTAINER_NAME >/dev/null 2>&1
fi

# Check if port is already in use
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null ; then
    print_error "Port $PORT is already in use. Please free up the port and try again."
    exit 1
fi

# Build the Docker image
print_message "Building Docker image..."
if ! docker build -t $IMAGE_NAME . ; then
    print_error "Failed to build Docker image"
    exit 1
fi

# Run the container
print_message "Starting container..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:$PORT \
    -e SECRET_KEY=development-key \
    -e FLASK_ENV=development \
    -e PORT=$PORT \
    $IMAGE_NAME

if [ $? -ne 0 ]; then
    print_error "Failed to start container"
    exit 1
fi

# Wait for the application to start
print_message "Waiting for application to start..."
sleep 3

# Check if the application is running
if curl -s http://localhost:$PORT/health > /dev/null; then
    print_message "Application is running! 🚀"
    print_message "Access the application at:"
    print_message "  → http://localhost:$PORT"
    print_message "  → http://localhost:$PORT/health"
    
    # Show container logs
    print_message "\nContainer logs:"
    docker logs $CONTAINER_NAME
else
    print_error "Application failed to start. Checking logs..."
    docker logs $CONTAINER_NAME
    exit 1
fi

# Helper commands
print_message "\nUseful commands:"
echo -e "${YELLOW}View logs:${NC} docker logs $CONTAINER_NAME"
echo -e "${YELLOW}Stop app:${NC} docker stop $CONTAINER_NAME"
echo -e "${YELLOW}Start app:${NC} docker start $CONTAINER_NAME"
echo -e "${YELLOW}Restart app:${NC} docker restart $CONTAINER_NAME"
echo -e "${YELLOW}Remove app:${NC} docker rm -f $CONTAINER_NAME" 