// This defines the Engineer model 
class Engineer {
  final int id;
  final String name;
  final String specialty;
  final String description;
  final double rating;
  final String location;
  final int projects;
  final int reviews;
  final String imageUrl;
  final String experience;
  final String hourlyRate;
  final List<String> tags;
  final String email;
  final String phone;

  Engineer({
    required this.id,
    required this.name,
    required this.specialty,
    required this.description,
    required this.rating,
    required this.location,
    required this.projects,
    required this.reviews,
    required this.imageUrl,
    required this.experience,
    required this.hourlyRate,
    required this.tags,
    required this.email,
    required this.phone,
  });

  // This converts JSON from the Flask backend into an Engineer object
  factory Engineer.fromJson(Map<String, dynamic> json) {
    return Engineer(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      specialty: json['specialty'] ?? 'General',
      description: json['description'] ?? '',
      // Backend might send doubles as ints, so we use .toDouble()
      rating: (json['rating'] ?? 0.0).toDouble(), 
      location: json['location'] ?? 'Not specified',
      projects: json['projects'] ?? 0,
      reviews: json['reviews'] ?? 0,
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? 'https://via.placeholder.com/150',
      experience: json['experience'] ?? 'Not specified',
      hourlyRate: json['hourly_rate'] ?? json['hourlyRate'] ?? 'Not specified',
      tags: List<String>.from(json['tags'] ?? []),
      email: json['email'] ?? 'Not provided',
      phone: json['phone'] ?? 'Not provided',
    );
  }

  // Convert Engineer object to JSON for sending to backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'description': description,
      'rating': rating,
      'location': location,
      'projects': projects,
      'reviews': reviews,
      'image_url': imageUrl,
      'experience': experience,
      'hourly_rate': hourlyRate,
      'tags': tags,
      'email': email,
      'phone': phone,
    };
  }
}

  
// Dummy data for testing purposes (Engineering Version)
final List<Engineer> engineerDummyData = [
  Engineer(
    id: 1,
    name: "Dr. Sarah Chan",
    specialty: "Structural Engineer",
    description: "Expert in high-rise structural integrity and modern seismic design.",
    rating: 4.8,
    location: "Colombo",
    projects: 287,
    reviews: 62,
    imageUrl: "https://picsum.photos/seed/dr_sarah/200/300",
    experience: "15+ years",
    hourlyRate: "LKR 2000/hr",
    tags: ["Soil Analysis", "Foundation Design", "Load Calculations"],
    email: "sarah.chan@buildpro.com",
    phone: "+94764801315",
  ),
  Engineer(
    id: 2,
    name: "Eng. Sarah Ahmed",
    specialty: "Civil Engineering",
    description: "Specialized in urban infrastructure and sustainable drainage systems.",
    rating: 4.7,
    location: "Kandy",
    projects: 30,
    reviews: 41,
    imageUrl: "https://picsum.photos/seed/eng2/200/300",
    experience: "15+ years",
    hourlyRate: "LKR 2000/hr",
    tags: ["Soil Analysis", "Foundation Design", "Load Calculations"],
    email: "sarah.ahmed@buildpro.com",
    phone: "(+94) 76 234 5678",
  ),
  Engineer(
    id: 3,
    name: "Apex Engineering Solutions",
    specialty: "MEP Engineering",
    description: "Providing high-end Mechanical, Electrical, and Plumbing blueprints.",
    rating: 4.8,
    location: "Galle",
    projects: 120,
    reviews: 88,
    imageUrl: "https://picsum.photos/seed/eng3/200/300",
    experience: "15+ years",
    hourlyRate: "LKR 2000/hr",
    tags: ["Soil Analysis", "Foundation Design", "Load Calculations"],
    email: "contact@apex.com",
    phone: "(+94) 75 456 7890",
  ),
];
