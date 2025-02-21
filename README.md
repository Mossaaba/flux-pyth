# Flask Application Template

A production-ready Flask application template with Docker support, security features, and best practices implemented.

## 🚀 Features

- Flask REST API
- Docker support
- CORS enabled
- Security headers
- Logging system
- Health check endpoint
- Error handling
- Environment configuration
- Docker compose setup

## 🛠️ Prerequisites

- Python 3.11+
- Docker (optional)
- pip

## 🔧 Installation

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/flask-template.git
   cd flask-template
   ```

2. Create and activate virtual environment:


## 🔒 Environment Variables

| Variable    | Description           | Default     |
|-------------|--------------------|-------------|
| FLASK_ENV   | Environment mode   | dev  |
| SECRET_KEY  | App secret key    | None        |
| PORT        | Application port   | 5001        |

## 🛣️ API Endpoints

| Method | Endpoint | Description    |
|--------|----------|----------------|
| GET    | /        | Root endpoint  |
| GET    | /health  | Health check   |
| GET    | /time    | Current time   | ?tz=timezone    |

## 🔐 Security

- Non-root user in Docker
- Security headers implemented
- CORS protection
- Error handling
- Logging system

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## ⚠️ Common Issues

1. **Port already in use**
   ```bash
   sudo lsof -i :5001  # Find process using port
   sudo kill -9 <PID>  # Kill process
   ```

2. **Docker permission denied**
   ```bash
   sudo usermod -aG docker $USER  # Add user to docker group
   newgrp docker                  # Activate changes
   ```

## 📫 Support
## Run the app : 

### Localy (VENV)

1. Create and Activate a Virtual Environment (Optional but Recommended) 

- python -m venv venv  # Create a virtual environment
- source venv/bin/activate  # Activate on macOS/Linux
- venv\Scripts\activate  # Activate on Windows

2. install requirments : 

pip install -r requirements.txt

3. export FLASK_APP=app.py  # On macOS/Linux
          set FLASK_APP=app.py  # On Windows
4. flask run


### Localy (DOCKER)

1. Run ./bin/run_cluster.sh




## Flux 


1- add  access token (classic)
2- create flux folder and add (Kustomzation.yaml, source.yaml)
3- update Kustomzation to use K8S/base deployement 


flux bootstrap github \
  --owner=Mossaaba \
  --repository=flux-pyth \
  --branch=main \
  --path=flux \
  --personal
  
4- apply kustomization and source 
kubectl apply -f flux/kustomization.yaml   
kubectl apply -f flux/source.yaml    

5- check pods 

kubectl get kustomizations 
kubectl get sources git 

kubectl get pods -n flux-system
kubectl get pods -n python-web-app-ns


# Manully 
flux reconcile source git flux-system
flux reconcile kustomization python-web-app