"""
Engineer Routes
Handles all engineer-related API endpoints
"""

from flask import Blueprint, request, jsonify
from models import Engineer
from database import db

# Create Blueprint
engineers_bp = Blueprint('engineers', __name__, url_prefix='/api')


@engineers_bp.route('/engineers', methods=['GET'])
def get_engineers():
    """
    GET /engineers
    Return all engineers with optional filtering
    
    Query Parameters:
    - search: Search by name
    - specialty: Filter by specialty
    - location: Filter by location
    """
    try:
        # Start with base query
        query = Engineer.query
        
        # Apply search filter
        search = request.args.get('search', '')
        if search:
            query = query.filter(
                (Engineer.name.ilike(f'%{search}%')) |
                (Engineer.description.ilike(f'%{search}%'))
            )
        
        # Apply specialty filter
        specialty = request.args.get('specialty', '')
        if specialty:
            query = query.filter(Engineer.specialty.ilike(f'%{specialty}%'))
        
        # Apply location filter
        location = request.args.get('location', '')
        if location:
            query = query.filter(Engineer.location.ilike(f'%{location}%'))
        
        # Get all engineers matching criteria
        engineers = query.all()
        
        # Convert to dictionary format
        result = [engineer.to_dict() for engineer in engineers]
        
        return jsonify(result), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@engineers_bp.route('/engineers/<int:engineer_id>', methods=['GET'])
def get_engineer_detail(engineer_id):
    """
    GET /engineers/<id>
    Return full details of a single engineer including email and phone
    """
    try:
        engineer = Engineer.query.get(engineer_id)
        
        if not engineer:
            return jsonify({'error': 'Engineer not found'}), 404
        
        return jsonify(engineer.to_dict()), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@engineers_bp.route('/engineers', methods=['POST'])
def create_engineer():
    """
    POST /engineers
    Create a new engineer (admin only)
    
    Body:
    {
        "name": "string",
        "specialty": "string",
        "description": "string",
        "location": "string",
        "email": "string",
        "phone": "string",
        "experience": "string",
        "hourly_rate": "string",
        "tags": ["string"]
    }
    """
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['name', 'specialty', 'location', 'email', 'phone']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Missing field: {field}'}), 400
        
        # Convert tags list to comma-separated string
        tags = ','.join(data.get('tags', [])) if isinstance(data.get('tags'), list) else data.get('tags', '')
        
        # Create new engineer
        engineer = Engineer(
            name=data['name'],
            specialty=data['specialty'],
            description=data.get('description', ''),
            location=data['location'],
            email=data['email'],
            phone=data['phone'],
            rating=data.get('rating', 0.0),
            projects=data.get('projects', 0),
            reviews=data.get('reviews', 0),
            image_url=data.get('image_url'),
            experience=data.get('experience'),
            hourly_rate=data.get('hourly_rate'),
            tags=tags
        )
        
        # Add to database
        db.session.add(engineer)
        db.session.commit()
        
        return jsonify({
            'message': 'Engineer created successfully',
            'engineer': engineer.to_dict()
        }), 201
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@engineers_bp.route('/engineers/<int:engineer_id>', methods=['PUT'])
def update_engineer(engineer_id):
    """
    PUT /engineers/<id>
    Update engineer details
    """
    try:
        engineer = Engineer.query.get(engineer_id)
        
        if not engineer:
            return jsonify({'error': 'Engineer not found'}), 404
        
        data = request.get_json()
        
        # Update fields
        if 'name' in data:
            engineer.name = data['name']
        if 'specialty' in data:
            engineer.specialty = data['specialty']
        if 'description' in data:
            engineer.description = data['description']
        if 'location' in data:
            engineer.location = data['location']
        if 'email' in data:
            engineer.email = data['email']
        if 'phone' in data:
            engineer.phone = data['phone']
        if 'rating' in data:
            engineer.rating = data['rating']
        if 'projects' in data:
            engineer.projects = data['projects']
        if 'reviews' in data:
            engineer.reviews = data['reviews']
        if 'image_url' in data:
            engineer.image_url = data['image_url']
        if 'experience' in data:
            engineer.experience = data['experience']
        if 'hourly_rate' in data:
            engineer.hourly_rate = data['hourly_rate']
        if 'tags' in data:
            tags = ','.join(data['tags']) if isinstance(data['tags'], list) else data['tags']
            engineer.tags = tags
        
        # Commit changes
        db.session.commit()
        
        return jsonify({
            'message': 'Engineer updated successfully',
            'engineer': engineer.to_dict()
        }), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@engineers_bp.route('/engineers/<int:engineer_id>', methods=['DELETE'])
def delete_engineer(engineer_id):
    """
    DELETE /engineers/<id>
    Delete an engineer
    """
    try:
        engineer = Engineer.query.get(engineer_id)
        
        if not engineer:
            return jsonify({'error': 'Engineer not found'}), 404
        
        db.session.delete(engineer)
        db.session.commit()
        
        return jsonify({'message': 'Engineer deleted successfully'}), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
