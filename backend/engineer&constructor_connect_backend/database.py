"""
Database Configuration and Initialization
Handles SQLAlchemy setup for the Flask application
"""

from flask_sqlalchemy import SQLAlchemy

# Initialize SQLAlchemy instance
db = SQLAlchemy()


def init_db(app):
    """
    Initialize the database with the Flask app
    
    Args:
        app: Flask application instance
    """
    db.init_app(app)
    
    with app.app_context():
        # Create all database tables
        db.create_all()
        print("✓ Database initialized successfully!")


def seed_database(app):
    """
    Populate database with sample data for testing
    
    Args:
        app: Flask application instance
    """
    from models import User, Constructor, Request
    
    with app.app_context():
        # Check if data already exists
        if Constructor.query.first() is not None:
            print("✓ Database already seeded!")
            return
        
        # Create sample users
        user1 = User(name="Rajith Perera", email="rajith@email.com", role="customer")
        user1.set_password("password123")
        
        user2 = User(name="Nimal Silva", email="nimal@email.com", role="customer")
        user2.set_password("password123")
        
        db.session.add(user1)
        db.session.add(user2)
        db.session.commit()
        
        # Create sample constructors
        constructors = [
            Constructor(
                name="BuildPro Construction",
                specialty="Residential",
                description="Contemporary residential construction focusing on modern aesthetics and sustainable building practices.",
                rating=5.0,
                location="Kandy",
                projects=100,
                reviews=124,
                image_url="https://picsum.photos/seed/buildpro/200/300",
                email="buildpro@email.com",
                phone="+94 701234567"
            ),
            Constructor(
                name="ModernSpace Builders",
                specialty="Commercial",
                description="Specialized in high-end residential and commercial projects with 15+ years experience.",
                rating=4.8,
                location="Colombo",
                projects=89,
                reviews=95,
                image_url="https://picsum.photos/seed/modernspace/200/300",
                email="modernspace@email.com",
                phone="+94 702345678"
            ),
            Constructor(
                name="Artisan Custom Homes",
                specialty="Residential",
                description="Contemporary residential construction with attention to detail and custom designs.",
                rating=5.0,
                location="Galle",
                projects=80,
                reviews=114,
                image_url="https://picsum.photos/seed/artisan/200/300",
                email="artisan@email.com",
                phone="+94 703456789"
            ),
            Constructor(
                name="Elite Infrastructure",
                specialty="Infrastructure",
                description="Expert in large-scale infrastructure and industrial projects.",
                rating=4.7,
                location="Colombo",
                projects=45,
                reviews=67,
                image_url="https://picsum.photos/seed/elite/200/300",
                email="elite@email.com",
                phone="+94 704567890"
            ),
            Constructor(
                name="Green Build Solutions",
                specialty="Eco-Friendly",
                description="Sustainable and eco-friendly construction with renewable energy integration.",
                rating=4.9,
                location="Kandy",
                projects=62,
                reviews=88,
                image_url="https://picsum.photos/seed/green/200/300",
                email="greenbuild@email.com",
                phone="+94 705678901"
            ),
        ]
        
        for constructor in constructors:
            db.session.add(constructor)
        
        db.session.commit()
        print(f"✓ Seeded {len(constructors)} constructors!")