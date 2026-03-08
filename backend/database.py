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
    from models import User, Constructor, Engineer, Request
    
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
        # Create sample engineers
        engineers = [
            Engineer(
                name="Dr. Sarah Chan",
                specialty="Structural Engineer",
                description="Expert in high-rise structural integrity and modern seismic design.",
                rating=4.8,
                location="Colombo",
                projects=287,
                reviews=62,
                image_url="https://picsum.photos/seed/sarah_chan/200/300",
                email="sarah.chan@buildpro.com",
                phone="+94764801315",
                experience="15+ years",
                hourly_rate="LKR 2000/hr",
                tags="Soil Analysis,Foundation Design,Load Calculations"
            ),
            Engineer(
                name="Eng. Sarah Ahmed",
                specialty="Civil Engineer",
                description="Specialized in drainage, water supply systems, and urban planning infrastructure.",
                rating=4.6,
                location="Kandy",
                projects=156,
                reviews=43,
                image_url="https://picsum.photos/seed/sarah_ahmed/200/300",
                email="sarah.ahmed@infrastructure.com",
                phone="(+94) 76 234 5678",
                experience="12+ years",
                hourly_rate="LKR 1800/hr",
                tags="Water Supply,Drainage Systems,Urban Planning"
            ),
            Engineer(
                name="Eng. James Rodrigues",
                specialty="Electrical Engineer",
                description="Expert in power distribution, renewable energy systems, and smart building automation.",
                rating=4.9,
                location="Galle",
                projects=234,
                reviews=78,
                image_url="https://picsum.photos/seed/james_rod/200/300",
                email="james.rodrigues@electrical.com",
                phone="(+94) 77 345 6789",
                experience="18+ years",
                hourly_rate="LKR 2200/hr",
                tags="Power Distribution,Renewable Energy,Building Automation"
            ),
            Engineer(
                name="Eng. Priya Sharma",
                specialty="Mechanical Engineer",
                description="Specialist in HVAC systems, mechanical design, and sustainability engineering.",
                rating=4.7,
                location="Colombo",
                projects=178,
                reviews=55,
                image_url="https://picsum.photos/seed/priya_sh/200/300",
                email="priya.sharma@mechanical.com",
                phone="(+94) 76 456 7890",
                experience="14+ years",
                hourly_rate="LKR 1900/hr",
                tags="HVAC Design,Mechanical Systems,Sustainability"
            ),
            Engineer(
                name="Eng. Marcus Thompson",
                specialty="Environmental Engineer",
                description="Expert in environmental impact assessment, waste management, and sustainable design.",
                rating=4.8,
                location="Kandy",
                projects=195,
                reviews=71,
                image_url="https://picsum.photos/seed/marcus_th/200/300",
                email="marcus.thompson@environmental.com",
                phone="(+94) 77 567 8901",
                experience="16+ years",
                hourly_rate="LKR 2100/hr",
                tags="Environmental Assessment,Waste Management,Sustainable Design"
            ),
        ]
        
        for engineer in engineers:
            db.session.add(engineer)
        
        db.session.commit()
        print(f"✓ Seeded {len(engineers)} engineers!")