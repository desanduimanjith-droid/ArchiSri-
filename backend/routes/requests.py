"""
Requests Routes
Handles all request-related API endpoints
"""

from flask import Blueprint, request, jsonify
from models import Request, User, Constructor
from database import db

# Create Blueprint
requests_bp = Blueprint('requests', __name__, url_prefix='/api')


@requests_bp.route('/requests', methods=['POST'])
def create_request():
    """
    POST /requests
    Create a new request from a customer to a constructor
    
    Body:
    {
        "user_id": int,
        "constructor_id": int,
        "message": "string"
    }
    """
    try:
        data = request.get_json()
        
        # Validate required fields
        if 'user_id' not in data or 'constructor_id' not in data or 'message' not in data:
            return jsonify({'error': 'Missing required fields: user_id, constructor_id, message'}), 400
        
        # Verify user and constructor exist
        user = User.query.get(data['user_id'])
        constructor = Constructor.query.get(data['constructor_id'])
        
        if not user:
            return jsonify({'error': 'User not found'}), 404
        if not constructor:
            return jsonify({'error': 'Constructor not found'}), 404
        
        # Create new request
        new_request = Request(
            user_id=data['user_id'],
            constructor_id=data['constructor_id'],
            message=data['message'],
            status='pending'
        )
        
        db.session.add(new_request)
        db.session.commit()
        
        return jsonify(new_request.to_dict()), 201
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@requests_bp.route('/requests/<int:user_id>', methods=['GET'])
def get_user_requests(user_id):
    """
    GET /requests/<user_id>
    Return all requests made by a specific user
    
    Query Parameters:
    - status: Filter by status (pending, accepted, rejected)
    """
    try:
        # Verify user exists
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Get requests with optional status filter
        query = Request.query.filter_by(user_id=user_id)
        
        status = request.args.get('status', '')
        if status:
            query = query.filter_by(status=status)
        
        requests_list = query.all()
        
        result = [req.to_dict() for req in requests_list]
        
        return jsonify(result), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@requests_bp.route('/requests/<int:request_id>', methods=['GET'])
def get_request_detail(request_id):
    """
    GET /requests/<request_id>
    Return details of a specific request
    """
    try:
        req = Request.query.get(request_id)
        
        if not req:
            return jsonify({'error': 'Request not found'}), 404
        
        return jsonify(req.to_dict()), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@requests_bp.route('/requests/<int:request_id>', methods=['PUT'])
def update_request(request_id):
    """
    PUT /requests/<request_id>
    Update request status (accept/reject)
    
    Body:
    {
        "status": "accepted" or "rejected"
    }
    """
    try:
        req = Request.query.get(request_id)
        
        if not req:
            return jsonify({'error': 'Request not found'}), 404
        
        data = request.get_json()
        
        # Validate status
        if 'status' not in data:
            return jsonify({'error': 'Missing field: status'}), 400
        
        valid_statuses = ['pending', 'accepted', 'rejected']
        if data['status'] not in valid_statuses:
            return jsonify({'error': f'Invalid status. Must be one of: {valid_statuses}'}), 400
        
        req.status = data['status']
        db.session.commit()
        
        return jsonify(req.to_dict()), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@requests_bp.route('/requests/<int:request_id>', methods=['DELETE'])
def delete_request(request_id):
    """
    DELETE /requests/<request_id>
    Delete a request
    """
    try:
        req = Request.query.get(request_id)
        
        if not req:
            return jsonify({'error': 'Request not found'}), 404
        
        db.session.delete(req)
        db.session.commit()
        
        return jsonify({'message': 'Request deleted successfully'}), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@requests_bp.route('/constructor/<int:constructor_id>/requests', methods=['GET'])
def get_constructor_requests(constructor_id):
    """
    GET /constructor/<constructor_id>/requests
    Return all requests received by a constructor
    
    Query Parameters:
    - status: Filter by status (pending, accepted, rejected)
    """
    try:
        # Verify constructor exists
        constructor = Constructor.query.get(constructor_id)
        if not constructor:
            return jsonify({'error': 'Constructor not found'}), 404
        
        # Get requests with optional status filter
        query = Request.query.filter_by(constructor_id=constructor_id)
        
        status = request.args.get('status', '')
        if status:
            query = query.filter_by(status=status)
        
        requests_list = query.all()
        
        result = [req.to_dict() for req in requests_list]
        
        return jsonify(result), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500
