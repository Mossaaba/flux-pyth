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
| FLASK_ENV   | Environment mode   | production  |
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

For support, email your@email.com or open an issue in the repository.
