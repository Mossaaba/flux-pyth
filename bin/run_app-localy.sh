#!/bin/bash

# Define colors
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No colo


# alias run_localy="./bin/run_app-localy.sh"


# Step 1: Create a virtual environment
echo "Creating virtual environment..."
python3 -m venv venv

# Step 2: Activate the virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Step 3: Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Step 4: Set Flask environment variable
export FLASK_APP=app.py

# Step 5: Run Flask application
echo -e "${GREEN}Starting Flask app...${NC}"
flask run

# Step 5: Press CTRL+C to quit