"""
Chat Routes
Handles all chat and messaging-related API endpoints
"""

from flask import Blueprint, request, jsonify
from models import ChatMessage, User
from database import db
from sqlalchemy import and_, or_

# Create Blueprint
chat_bp = Blueprint('chat', __name__, url_prefix='/api')


@chat_bp.route('/chat', methods=['POST'])
def send_message():
    """
    POST /chat
    Send a new chat message
    
    Body:
    {
        "sender_id": int,
        "receiver_id": int,
        "message": "string"
    }
    """
    try:
        data = request.get_json()
        
        # Validate required fields
        required_fields = ['sender_id', 'receiver_id', 'message']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Missing required field: {field}'}), 400
        
        # Verify sender and receiver exist
        sender = User.query.get(data['sender_id'])
        receiver = User.query.get(data['receiver_id'])
        
        if not sender:
            return jsonify({'error': 'Sender not found'}), 404
        if not receiver:
            return jsonify({'error': 'Receiver not found'}), 404
        
        # Prevent sending messages to self
        if data['sender_id'] == data['receiver_id']:
            return jsonify({'error': 'Cannot send message to yourself'}), 400
        
        # Create new message
        message = ChatMessage(
            sender_id=data['sender_id'],
            receiver_id=data['receiver_id'],
            message=data['message']
        )
        
        db.session.add(message)
        db.session.commit()
        
        return jsonify(message.to_dict()), 201
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@chat_bp.route('/chat', methods=['GET'])
def get_chat_history():
    """
    GET /chat
    Return chat history between two users
    
    Query Parameters:
    - user1: First user ID (required)
    - user2: Second user ID (required)
    - limit: Number of messages to return (default: 50)
    """
    try:
        user1_id = request.args.get('user1', type=int)
        user2_id = request.args.get('user2', type=int)
        limit = request.args.get('limit', default=50, type=int)
        
        # Validate parameters
        if not user1_id or not user2_id:
            return jsonify({'error': 'Missing required parameters: user1, user2'}), 400
        
        # Verify users exist
        user1 = User.query.get(user1_id)
        user2 = User.query.get(user2_id)
        
        if not user1:
            return jsonify({'error': 'User1 not found'}), 404
        if not user2:
            return jsonify({'error': 'User2 not found'}), 404
        
        # Get all messages between the two users (both directions)
        messages = ChatMessage.query.filter(
            or_(
                and_(
                    ChatMessage.sender_id == user1_id,
                    ChatMessage.receiver_id == user2_id
                ),
                and_(
                    ChatMessage.sender_id == user2_id,
                    ChatMessage.receiver_id == user1_id
                )
            )
        ).order_by(ChatMessage.timestamp.asc()).limit(limit).all()
        
        result = [msg.to_dict() for msg in messages]
        
        return jsonify(result), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@chat_bp.route('/chat/<int:user_id>/conversations', methods=['GET'])
def get_user_conversations(user_id):
    """
    GET /chat/<user_id>/conversations
    Return all conversations for a user (list of unique users they've chatted with)
    """
    try:
        # Verify user exists
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Get all unique users this user has communicated with
        sent_messages = ChatMessage.query.filter_by(sender_id=user_id).all()
        received_messages = ChatMessage.query.filter_by(receiver_id=user_id).all()
        
        # Collect unique user IDs
        unique_users = set()
        for msg in sent_messages:
            unique_users.add(msg.receiver_id)
        for msg in received_messages:
            unique_users.add(msg.sender_id)
        
        # Get user details
        conversations = []
        for other_user_id in unique_users:
            other_user = User.query.get(other_user_id)
            if other_user:
                # Get last message
                last_message = ChatMessage.query.filter(
                    or_(
                        and_(
                            ChatMessage.sender_id == user_id,
                            ChatMessage.receiver_id == other_user_id
                        ),
                        and_(
                            ChatMessage.sender_id == other_user_id,
                            ChatMessage.receiver_id == user_id
                        )
                    )
                ).order_by(ChatMessage.timestamp.desc()).first()
                
                conversations.append({
                    'user_id': other_user.id,
                    'name': other_user.name,
                    'email': other_user.email,
                    'last_message': last_message.message if last_message else None,
                    'last_message_time': last_message.timestamp.isoformat() if last_message else None
                })
        
        # Sort by last message time
        conversations.sort(
            key=lambda x: x['last_message_time'] if x['last_message_time'] else '',
            reverse=True
        )
        
        return jsonify(conversations), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@chat_bp.route('/chat/<int:message_id>', methods=['DELETE'])
def delete_message(message_id):
    """
    DELETE /chat/<message_id>
    Delete a specific message
    """
    try:
        message = ChatMessage.query.get(message_id)
        
        if not message:
            return jsonify({'error': 'Message not found'}), 404
        
        db.session.delete(message)
        db.session.commit()
        
        return jsonify({'message': 'Message deleted successfully'}), 200
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
