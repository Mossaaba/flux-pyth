from flask import Flask, jsonify, request
from flask_cors import CORS
from werkzeug.exceptions import HTTPException
import logging
import os
from datetime import datetime
import pytz  # Add this import at the top


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configuration
class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'your-secret-key-here')
    ENVIRONMENT = os.environ.get('FLASK_ENV', 'dev')
    
app.config.from_object(Config)

# Middleware for request logging
@app.before_request
def log_request_info():
    logger.info(f'Request: {request.method} {request.url} - {request.remote_addr}')

# Add security headers
@app.after_request
def add_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains'
    return response

@app.errorhandler(HTTPException)
def handle_http_error(error):
    logger.error(f'HTTP Error: {error.code} - {error.description}')
    return jsonify({
        'error': error.name,
        'message': error.description,
        'timestamp': datetime.utcnow().isoformat()
    }), error.code

@app.errorhandler(Exception)
def handle_generic_error(error):
    logger.error(f'Unexpected Error: {str(error)}')
    return jsonify({
        'error': 'Internal Server Error',
        'message': 'An unexpected error occurred',
        'timestamp': datetime.utcnow().isoformat()
    }), 500

@app.route('/time')
def get_time():
    """Get current time in different formats and timezones"""
    utc_time = datetime.now(pytz.UTC)
    
    # Get timezone from query parameter or default to UTC
    timezone = request.args.get('tz', 'UTC')
    try:
        local_time = utc_time.astimezone(pytz.timezone(timezone))
    except pytz.exceptions.UnknownTimeZoneError:
        return jsonify({
            'error': 'Invalid timezone',
            'message': f'Timezone "{timezone}" not found',
            'valid_timezones': 'See https://en.wikipedia.org/wiki/List_of_tz_database_time_zones'
        }), 400

    return jsonify({
        'utc': utc_time.isoformat(),
        'local': local_time.isoformat(),
        'timezone': timezone,
        'timestamp': int(utc_time.timestamp())
    })

@app.route('/')
def hello():
    logger.info('Processing request to root endpoint')
    return jsonify({
        'message': 'Hello :)',
        'status': 'success',
        'timestamp': datetime.utcnow().isoformat(),
        'environment': app.config['ENVIRONMENT']
    })

@app.route('/hola')
def holla():
    logger.info('Processing request to root endpoint')
    return jsonify({
        'message': 'Hola :)',
        'status': 'success',
        'timestamp': datetime.utcnow().isoformat(),
        'environment': app.config['ENVIRONMENT']
    })

@app.route('/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat()
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5001))
    debug = app.config['ENVIRONMENT'] == 'development'
    
    logger.info(f'Starting application on port {port} in {app.config["ENVIRONMENT"]} mode')
    app.run(host='0.0.0.0', port=port, debug=debug)