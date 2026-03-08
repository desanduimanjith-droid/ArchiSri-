"""
Constructor Routes
Handles all constructor-related API endpoints
"""

from flask import Blueprint, request, jsonify
from models import Constructor
from database import db

# Create Blueprint
constructors_bp = Blueprint('constructors', __name__, url_prefix='/api')


@constructors_bp.route('/constructors', methods=['GET'])
def get_constructors():
    """
    GET /constructors
    Return all constructors with optional filtering
    
    Query Parameters:
    - search: Search by name
    - specialty: Filter by specialty
    - location: Filter by location
    """
    try:
        # Start with base query
        query = Constructor.query
        
        # Apply search filter
        search = request.args.get('search', '')
        if search:
            query = query.filter(
                (Constructor.name.ilike(f'%{search}%')) |
                (Constructor.description.ilike(f'%{search}%'))
            )
        
        # Apply specialty filter
        specialty = request.args.get('specialty', '')
        if specialty:
            query = query.filter(Constructor.specialty.ilike(f'%{specialty}%'))
        
        # Apply location filter
        location = request.args.get('location', '')
        if location:
            query = query.filter(Constructor.location.ilike(f'%{location}%'))
        
        # Get all constructors matching criteria
        constructors = query.all()
        
        # Convert to dictionary format
        result = [constructor.to_dict() for constructor in constructors]
        
        return jsonify(result), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@constructors_bp.route('/constructors/<int:constructor_id>', methods=['GET'])
def get_constructor_detail(constructor_id):
    """
    GET /constructors/<id>
    Return full details of a single constructor including email and phone
    """
    try:
        constructor = Constructor.query.get(constructor_id)
        
        if not constructor:
            return jsonify({'error': 'Constructor not found'}), 404
        
        return jsonify(constructor.to_dict_full()), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@constructors_bp.route('/constructors', methods=['POST'])
def create_constructor():
    """
    POST /constructors
    Create a new constructor (admin only)
    
    Body:
    {
        "name": "string",
        "specialty": "string",
        "description": "string",
        "location": "string",
        "email": "string",
        "phone": "string"
    }
    """
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['name', 'specialty', 'location', 'email', 'phone']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Missing field: {field}'}), 400
        
        # Create new constructor
        constructor = Constructor(
            name=data['name'],
            specialty=data['specialty'],
            description=data.get('description', ''),
            location=data['location'],
            email=data['email'],
            phone=data['phone'],
            image_url=data.get('image_url', 'https://via.placeholder.com/200'),
            rating=data.get('rating', 0.0),
            projects=data.get('projects', 0),
            reviews=data.get('reviews', 0)
        )
        
        db.session.add(constructor)
        db.session.commit()
        
        return jsonify(constructor.to_dict()), 201
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@constructors_bp.route('/constructors/<int:constructor_id>', methods=['PUT'])
def update_constructor(constructor_id):
    """
    PUT /constructors/<id>
    Update an existing constructor
    """
    try:
        constructor = Constructor.query.get(constructor_id)
        
        if not constructor:
            return jsonify({'error': 'Constructor not found'}), 404
        
        data = request.get_json()
        
        # Update fields if provided
        if 'name' in data:
            constructor.name = data['name']
        if 'specialty' in data:
            constructor.specialty = data['specialty']
        if 'description' in data:
            constructor.description = data['description']
        if 'location' in data:
            constructor.location = data['location']
        if 'email' in data:
            constructor.email = data['email']
        if 'phone' in data:
            constructor.phone = data['phone']
        if 'image_url' in data:
            constructor.image_url = data['image_url']
        if 'rating' in data:
            constructor.rating = data['rating']
        if 'projects' in data:
            constructor.projects = data['projects']
        if 'reviews' in data:
            constructor.reviews = data['reviews']
        
        db.session.commit()
        
        return jsonify(constructor.to_dict()), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@constructors_bp.route('/constructors/<int:constructor_id>', methods=['DELETE'])
def delete_constructor(constructor_id):
    """
    DELETE /constructors/<id>
    Delete a constructor
    """
    try:
        constructor = Constructor.query.get(constructor_id)
        
        if not constructor:
            return jsonify({'error': 'Constructor not found'}), 404
        
        db.session.delete(constructor)
        db.session.commit()
        
        return jsonify({'message': 'Constructor deleted successfully'}), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
