"""
Database Models for Constructor Connect Backend
Defines all SQLAlchemy models for the application
"""

from database import db
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash


class User(db.Model):
    """
    User Model - Represents users (customers and constructors)
    """
    __tablename__ = 'users'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), nullable=False)  # "customer" or "constructor"
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationships
    requests_made = db.relationship('Request', foreign_keys='Request.user_id', backref='user', cascade='all, delete-orphan')
    
    def set_password(self, password):
        """Hash and set password"""
        self.password_hash = generate_password_hash(password)
    
    def check_password(self, password):
        """Check if provided password matches hash"""
        return check_password_hash(self.password_hash, password)
    
    def to_dict(self):
        """Convert user to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'role': self.role,
            'created_at': self.created_at.isoformat()
        }


class Constructor(db.Model):
    """
    Constructor Model - Represents construction professionals
    """
    __tablename__ = 'constructors'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    specialty = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=True)
    rating = db.Column(db.Float, default=0.0)
    location = db.Column(db.String(100), nullable=False)
    projects = db.Column(db.Integer, default=0)
    reviews = db.Column(db.Integer, default=0)
    image_url = db.Column(db.String(500), nullable=True)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    # Relationships
    requests = db.relationship('Request', backref='constructor', cascade='all, delete-orphan')
    
    def to_dict(self):
        """Convert constructor to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'specialty': self.specialty,
            'description': self.description,
            'rating': self.rating,
            'location': self.location,
            'projects': self.projects,
            'reviews': self.reviews,
            'image_url': self.image_url,
            'email': self.email,
            'phone': self.phone
        }
    
    def to_dict_full(self):
        """Convert constructor to full dictionary including email and phone"""
        return self.to_dict()


class Request(db.Model):
    """
    Request Model - Represents requests sent by customers to constructors
    """
    __tablename__ = 'requests'
    
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    constructor_id = db.Column(db.Integer, db.ForeignKey('constructors.id'), nullable=False)
    message = db.Column(db.Text, nullable=False)
    status = db.Column(db.String(20), default='pending')  # "pending", "accepted", "rejected"
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        """Convert request to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'constructor_id': self.constructor_id,
            'user_name': self.user.name if self.user else None,
            'constructor_name': self.constructor.name if self.constructor else None,
            'message': self.message,
            'status': self.status,
            'timestamp': self.timestamp.isoformat()
        }


class Engineer(db.Model):
    """
    Engineer Model - Represents engineering professionals
    """
    __tablename__ = 'engineers'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    specialty = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text, nullable=True)
    rating = db.Column(db.Float, default=0.0)
    location = db.Column(db.String(100), nullable=False)
    projects = db.Column(db.Integer, default=0)
    reviews = db.Column(db.Integer, default=0)
    image_url = db.Column(db.String(500), nullable=True)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    experience = db.Column(db.String(100), nullable=True)
    hourly_rate = db.Column(db.String(50), nullable=True)
    tags = db.Column(db.Text, nullable=True)  # Storing as comma-separated string
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    
    def to_dict(self):
        """Convert engineer to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'specialty': self.specialty,
            'description': self.description,
            'rating': self.rating,
            'location': self.location,
            'projects': self.projects,
            'reviews': self.reviews,
            'image_url': self.image_url,
            'email': self.email,
            'phone': self.phone,
            'experience': self.experience,
            'hourly_rate': self.hourly_rate,
            'tags': self.tags.split(',') if self.tags else []
        }