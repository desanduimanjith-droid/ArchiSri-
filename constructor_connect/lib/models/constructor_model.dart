// This defines the Constructor model 
class Constructor {
  //final String id;
  final String name;
  final String specialty;
  final String description;
  final double rating;
  final String location;
  final int projects;
  final int reviews;
  final String imageUrl;

  Constructor({
    required this.name,
    required this.specialty,
    required this.description,
    required this.rating,
    required this.location,
    required this.projects,
    required this.reviews,
    required this.imageUrl,
  });

  // This converts JSON from the backend into a Constructor object
  factory Constructor.fromJson(Map<String, dynamic> json) {
    return Constructor(
      name: json['name'] ?? 'Unknown',
      specialty: json['specialty'] ?? 'General',
      description: json['description'] ?? '',
      // Backend might send doubles as ints, so we use .toDouble()
      rating: (json['rating'] ?? 0.0).toDouble(), 
      location: json['location'] ?? 'Not specified',
      projects: json['projects'] ?? 0,
      reviews: json['reviews'] ?? 0,
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}

  
// Dummy data for testing purposes
final List<Constructor> dummyData = [
  Constructor(
    name: "BuildPro Construction",
    specialty: "Residential",
    description: "Contemporary residential construction focusing on modern aesthetics.",
    rating: 5.0,
    location: "Kandy",
    projects: 100,
    reviews: 124,
    imageUrl: "https://picsum.photos/seed/picsum/200/300",
  ),
  Constructor(
    name: "ModernSpace Builders",
    specialty: "Residential",
    description: "Specialized in high-end residential projects with 15+ years experience.",
    rating: 4.8,
    location: "Colombo",
    projects: 89,
    reviews: 95,
    imageUrl: "https://picsum.photos/seed/picsum/200/300",
  ),
  Constructor(
    name: "Artisan Custom Homes",
    specialty: "Residential",
    description: "Contemporary residential construction focusing on modern aesthetics.",
    rating: 5.0,
    location: "Galle",
    projects: 80,
    reviews: 114,
    imageUrl: "https://picsum.photos/seed/picsum/200/300",
  ),
];