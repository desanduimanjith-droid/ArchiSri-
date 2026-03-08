"""
Constructor Connect Backend
Flask REST API for Constructor Connect Flutter Application
"""

from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import os

# Import database and models
from database import init_db, seed_database, db
import models

# Import route blueprints
from routes.constructors import constructors_bp
from routes.requests import requests_bp
from routes.engineers import engineers_bp


def create_app():
    """
    Application factory function
    Creates and configures the Flask application
    """
    
    # Initialize Flask app
    app = Flask(__name__)
    
    # ===================================
    # CONFIGURATION
    # ===================================
    
    # Database configuration
    basedir = os.path.abspath(os.path.dirname(__file__))
    app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{os.path.join(basedir, "constructor_connect.db")}'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['UPLOAD_FOLDER'] = os.path.join(basedir, 'uploads')
    
    # ===================================
    # INITIALIZE EXTENSIONS
    # ===================================
    
    # Enable CORS for Flutter frontend
    CORS(app, resources={
        r"/api/*": {
            "origins": ["*"],
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    
    # Initialize database
    init_db(app)
    
    # ===================================
    # REGISTER BLUEPRINTS
    # ===================================
    
    app.register_blueprint(constructors_bp)
    app.register_blueprint(requests_bp)
    app.register_blueprint(engineers_bp)
    
    # ===================================
    # ERROR HANDLERS
    # ===================================
    
    @app.errorhandler(404)
    def not_found(error):
        """Handle 404 errors"""
        return jsonify({'error': 'Endpoint not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        """Handle 500 errors"""
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500
    
    # ===================================
    # HEALTH CHECK ENDPOINT
    # ===================================
    
    @app.route('/api/health', methods=['GET'])
    def health_check():
        """Health check endpoint"""
        return jsonify({
            'status': 'healthy',
            'message': 'Constructor Connect API is running'
        }), 200

    @app.route('/uploads/<path:filename>', methods=['GET'])
    def serve_upload(filename):
        """Serve uploaded files"""
        return send_from_directory(app.config['UPLOAD_FOLDER'], filename)
    
    # ===================================
    # SEED DATABASE
    # ===================================
    
    with app.app_context():
        # Create all tables
        db.create_all()
        # Seed with sample data
        seed_database(app)
    
    return app


if __name__ == '__main__':
    # Create the Flask app
    app = create_app()
    
    # Print available routes
    print("\n" + "="*60)
    print("CONSTRUCTOR CONNECT API")
    print("="*60)
    print("\n📍 Available Endpoints:\n")
    print("CONSTRUCTORS:")
    print("  GET    /api/constructors              - Get all constructors")
    print("  GET    /api/constructors/<id>         - Get constructor details")
    print("  POST   /api/constructors              - Create constructor")
    print("  PUT    /api/constructors/<id>         - Update constructor")
    print("  DELETE /api/constructors/<id>         - Delete constructor")
    print("\nREQUESTS:")
    print("  POST   /api/requests                  - Create request")
    print("  GET    /api/requests/<user_id>        - Get user's requests")
    print("  GET    /api/requests/<request_id>     - Get request details")
    print("  PUT    /api/requests/<request_id>     - Update request status")
    print("  DELETE /api/requests/<request_id>     - Delete request")
    print("  GET    /api/constructor/<id>/requests - Get requests for constructor")
    print("\nENGINEERS:")
    print("  GET    /api/engineers                 - Get all engineers")
    print("  GET    /api/engineers/<id>            - Get engineer details")
    print("\nHEALTH:")
    print("  GET    /api/health                    - Health check")
    
    # Run the Flask development server on port 8000
    app.run(debug=True, host='0.0.0.0', port=8000)
