import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> showRatingBottomSheet({
  required BuildContext context,
  required String name,
  required String imageUrl,
  required String currentRating,
  required String docId,
  required String collectionName,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => RatingSheetContent(
      name: name,
      imageUrl: imageUrl,
      currentRating: currentRating,
      docId: docId,
      collectionName: collectionName,
    ),
  );
}

class RatingSheetContent extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String currentRating;
  final String docId;
  final String collectionName;

  const RatingSheetContent({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.currentRating,
    required this.docId,
    required this.collectionName,
  });

  @override
  State<RatingSheetContent> createState() => _RatingSheetContentState();
}

class _RatingSheetContentState extends State<RatingSheetContent> {
  int _selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Skip button
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Avatar and Rating Badge
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: widget.imageUrl.isNotEmpty
                    ? NetworkImage(widget.imageUrl)
                    : null,
                child: widget.imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: -15,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber[400], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.currentRating,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Name
          Text(
            widget.name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 25),

          // Title
          const Text(
            'Rate your professional',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          // Subtitle
          Text(
            "What do you think about ${widget.name}'s service?",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 30),

          // Stars Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    _selectedRating = index + 1;
                  });

                  // Save new rating to Firestore via transaction
                  try {
                    final docRef = FirebaseFirestore.instance
                        .collection(widget.collectionName)
                        .doc(widget.docId);

                    await FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      final snapshot = await transaction.get(docRef);
                      if (!snapshot.exists) return;

                      final data = snapshot.data()!;
                      int currentCount = data['ratingCount'] ?? 0;
                      double currentVal = 0.0;
                      if (data['rating'] != null) {
                        currentVal =
                            double.tryParse('${data['rating']}') ?? 0.0;
                      }

                      double newRating =
                          ((currentVal * currentCount) + _selectedRating) /
                              (currentCount + 1);
                      double roundedRating =
                          double.parse(newRating.toStringAsFixed(1));

                      transaction.update(docRef, {
                        'rating': roundedRating,
                        'ratingCount': currentCount + 1,
                      });
                    });
                  } catch (e) {
                    debugPrint("Failed to update rating: $e");
                  }

                  // Automatically dismiss after rating with a tiny delay
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Thank you for your rating!')),
                      );
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    size: 45,
                    color: index < _selectedRating
                        ? Colors.amber[400]
                        : Colors.grey.shade300,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 30),

          // Compliment generic button text
          GestureDetector(
            onTap: () {
              // Could open a text field dialog in the future
            },
            child: const Text(
              'Give a compliment',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
