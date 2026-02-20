import 'package:flutter/material.dart';
import '../models/constructor_model.dart'; // Ensure this file has 'dummyData'
import '../service/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
// After ApI intergration this want to be a Stateful widget to handle the API data 
// class _HomeScreenState extends State<HomeScreen> {
//   // --- LOGIC VARIABLES ---
//   final ScrollController _scrollController = ScrollController();
//   List<Constructor> _constructors = [];
//   int _currentPage = 1;
//   bool _isLoading = false;
//   bool _hasMore = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchPage(); // Fetch first 20 constructors
    
//     // Listen to scrolling to load more items
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
//         _fetchPage();
//       }
//     });
//   }

//   Future<void> _fetchPage() async {
//     if (_isLoading || !_hasMore) return;
//     setState(() => _isLoading = true);

//     try {
//       // Calling the service we created
//       final newItems = await ApiService().fetchConstructors(page: _currentPage);
//       setState(() {
//         _currentPage++;
//         _isLoading = false;
//         if (newItems.isEmpty) {
//           _hasMore = false;
//         } else {
//           _constructors.addAll(newItems);
//         }
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   // Your existing filter pop-up function
//   void _openFilter() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFFFFF3F3),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) => const FilterSheet(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           // 1. YOUR HEADER (KEEPING YOUR DESIGN)
//           Container(
//             width: double.infinity,
//             height: 200,
//             padding: const EdgeInsets.all(20),
//             decoration: const BoxDecoration(
//               color: Color(0xFFCABF58),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   height: 120,
//                   width: 120,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFDD8436),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Icon(Icons.engineering, size: 90, color: Colors.black),
//                 ),
//                 const SizedBox(width: 20),
//                 const Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Connect with\nConstructors",
//                         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
//                       SizedBox(height: 8),
//                       Text("Find verified construction professionals",
//                         style: TextStyle(fontSize: 14, color: Colors.black87)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 2. SEARCH BAR SECTION
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(30)),
//                     child: const TextField(
//                       decoration: InputDecoration(hintText: "Search constructors", border: InputBorder.none, icon: Icon(Icons.search)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: _openFilter,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(color: const Color(0xFFFFF3F3), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
//                     child: const Icon(Icons.tune),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 3. THE INFINITE LIST (NEW DYNAMIC LOGIC)
//           Expanded(
//             child: _constructors.isEmpty && _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     controller: _scrollController,
//                     itemCount: _constructors.length + (_hasMore ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       if (index < _constructors.length) {
//                         return ConstructorCard(item: _constructors[index]);
//                       } else {
//                         return const Padding(
//                           padding: EdgeInsets.all(16.0),
//                           child: Center(child: CircularProgressIndicator()),
//                         );
//                       }
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }


class _HomeScreenState extends State<HomeScreen> {
  // Function to open the filter pop-up
  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF3F3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // The header banner
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFCABF58), // The light green background
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDD8436), // The icon box color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.engineering,
                    size: 90,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Connect with\nConstructors",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Find verified construction professionals",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- SEARCH BAR & FILTER BUTTON ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search constructors",
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // The Filter Icon
                GestureDetector(
                  onTap: _openFilter,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.tune, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // The constructors list
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "3 constructors found",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Fetch constructors from API
          Expanded(
            child: FutureBuilder<List<Constructor>>(
              future: ApiService().fetchConstructors(), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFCABF58)));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Error: ${snapshot.error}"),
                        ),
                        ElevatedButton(onPressed: () => setState(() {}), child: const Text("Retry"))
                      ],
                    ),
                  );
                }

                final constructors = snapshot.data ?? [];
                if (constructors.isEmpty) {
                  return const Center(child: Text("No constructors found."));
                }

                return ListView.builder(
                  itemCount: constructors.length,
                  itemBuilder: (context, index) => ConstructorCard(item: constructors[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}

// Constructor Card Widget
class ConstructorCard extends StatelessWidget {
  final Constructor item;
  const ConstructorCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFFFFF3F3),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          // Pop up constructorDetailSheet
          builder: (context) => ConstructorDetailSheet(item: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFFF3F3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber[600], size: 16),
                          Text(" ${item.rating}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16),
                          Text(" ${item.location}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.business_center_outlined, size: 16),
                          Text(" ${item.projects}"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The details sheet that opens when tap a constructor
class ConstructorDetailSheet extends StatelessWidget {
  final Constructor item;
  const ConstructorDetailSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      height:
          MediaQuery.of(context).size.height * 0.85, // Opens to 85% of screen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top drag bar
          Center(
            child: Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Header image and name
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.verified,
                          color: Color(0xFFD16BFF),
                        ), // verified badge
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.specialty,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.grey, thickness: 0.5),
          ),

          // About section
          const Text(
            "About",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            item.description,
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.grey, thickness: 0.5),
          ),

          // The stats row (Rating, Projects, Location)
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(
                  Icons.star_outline,
                  "${item.rating}",
                  "${item.reviews} reviews",
                ),
                const VerticalDivider(color: Colors.grey, thickness: 1),
                _buildStatColumn(
                  Icons.business_center_outlined,
                  "${item.projects}",
                  "Projects",
                ),
                const VerticalDivider(color: Colors.grey, thickness: 1),
                _buildStatColumn(
                  Icons.location_on_outlined,
                  item.location,
                  "District",
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Contact Information
          const Text(
            "Contact Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildContactCard(
            Icons.email_outlined,
            "Email",
            "contact@buildpro.com",
            const Color(0xFFE5D7F5),
          ),
          const SizedBox(height: 10),
          _buildContactCard(
            Icons.phone_outlined,
            "Phone",
            "(+94) 77 591 2426",
            const Color(0xFFF3E7D5),
          ),

          const Spacer(),

          // Send Request Button from send request
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the sheet
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: const Color(0xFFFFF3F3),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) =>
                    ChatSheet(item: item), // Call the chat sheet
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Send a request",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // Helper for the columns (Rating, Projects, Location)
  Widget _buildStatColumn(IconData icon, String val, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.black54),
        Text(
          val,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // Helper for the Contact cards
  Widget _buildContactCard(
    IconData icon,
    String title,
    String val,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.5),
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(val, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// Chat Screen Widget
class ChatSheet extends StatelessWidget {
  final Constructor item;
  const ChatSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      // Opens to 90% of screen height
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Top drag bar
          Center(
            child: Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // header: Avatar, Name, and Action Icons
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(item.imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.phone_outlined, size: 24),
              const SizedBox(width: 15),
              const Icon(Icons.videocam_outlined, size: 26),
              const SizedBox(width: 10),
              const Icon(Icons.more_vert),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.grey, thickness: 0.5),
          ),

          // chat area
          Expanded(
            child: ListView(
              children: [
                // Date Indicator
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E7D5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Message Bubble (Left Aligned)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E7D5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi! Thanks for connecting. I'm excited to discuss your architectural project!",
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.8),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "11:49 AM",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom message input bar
          // viewInsets.bottom to make the bar sit above the keyboard
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              top: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E7D5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E7D5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send_outlined, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Filter Sheet Widget
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  bool isVerified =
      false; // Tracks the checkbox state for Verified Constructors
  bool isResidential = false; // Tracks the checkbox state for Residential
  bool isCommercial = false; // Tracks the checkbox state for Commercial
  bool isIndustrial = false; // Tracks the checkbox state for Industrial
  bool isSustainable = false; // Tracks the checkbox state for Sustainable
  bool isRestoration = false; // Tracks the checkbox state for Restoration
  final List<String> _districts = [
    "Colombo",
    "Gampaha",
    "Kalutara",
    "Kandy",
    "Matale",
    "Nuwara Eliya",
    "Galle",
    "Matara",
    "Hambantota",
    "Jaffna",
    "Kilinochchi",
    "Mannar",
    "Vavuniya",
    "Mullaitivu",
    "Batticaloa",
    "Ampara",
    "Trincomalee",
    "Kurunegala",
    "Puttalam",
    "Anuradhapura",
    "Polonnaruwa",
    "Badulla",
    "Moneragala",
    "Ratnapura",
    "Kegalle",
  ];
  String? selectedDistrict; //  to store the selected district
  double _currentRating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The top drag bar
          Center(
            child: Container(
              width: 80,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Filters",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          // This Row handles the right side check box alignment
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // This pushes items to the far ends
            children: [
              const Text(
                "Verified Constructors Only",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              Checkbox(
                value: isVerified,
                activeColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    isVerified = value ?? false;
                  });
                },
              ),
            ],
          ),

          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Speciality",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Residential filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Residential", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isResidential, // Uses the separate residential variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isResidential = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Commercial filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Commercial", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isCommercial, // Uses the separate commercial variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isCommercial = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Industrial filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Industrial", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isIndustrial, // Uses the separate industrial variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isIndustrial = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Sustainable filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sustainable", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isSustainable, // Uses the separate sustainable variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isSustainable = value ?? false;
                  });
                },
              ),
            ],
          ),

          // Restoration filter with its own checkbox
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Restoration", style: TextStyle(fontSize: 14)),
              Checkbox(
                value: isRestoration, // Uses the separate restoration variable
                activeColor: Colors.black,
                visualDensity: const VisualDensity(vertical: -4),
                onChanged: (bool? value) {
                  setState(() {
                    isRestoration = value ?? false;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(),
          const SizedBox(height: 10),
          // Location dropdown
          const Text(
            "Location",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select District"),
                value: selectedDistrict,
                items: _districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            "Minimum Rating",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _currentRating,
            min: 0,
            max: 5,
            divisions: 5,
            label: _currentRating.toString(),
            activeColor: const Color(0xFFCABF58), // Using your header color
            onChanged: (v) {
              setState(() {
                _currentRating = v;
              });
            },
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "Show Results",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

