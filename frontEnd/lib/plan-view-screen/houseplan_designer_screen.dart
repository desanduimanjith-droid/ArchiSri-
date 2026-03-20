import 'package:archisri_1/main_content_part.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:archisri_1/Engineer-connect-feature/screens/engineer_screen.dart';
import 'package:archisri_1/Constructor-connect-feature/screens/constructor_screen.dart';
import 'package:archisri_1/marketPlace.dart';

class HouseplanDesignerScreen extends StatefulWidget {
  final int landsize;
  final int floors;
  final int bedrooms;
  final int bathrooms;
  final int kitchen;
  final int livingRoom;
  final String style;

  const HouseplanDesignerScreen({
    super.key,
    required this.landsize,
    required this.floors,
    required this.bedrooms,
    required this.bathrooms,
    required this.kitchen,
    required this.livingRoom,
    required this.style,
  });

  @override
  State<HouseplanDesignerScreen> createState() =>
      _HouseplanDesignerScreenState();
}

class _HouseplanDesignerScreenState extends State<HouseplanDesignerScreen> {
  bool _isLoading = false;
  Uint8List? _generatedBlueprintImage;
  double currentStep = 8;
  final double totalSteps = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateBlueprint();
    });
  }

  String _getBackendUrl() {
    if (kIsWeb) {
      return 'http://127.0.0.1:5002/blueprint';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://127.0.0.1:5002/blueprint';
    } else if (Platform.isAndroid) {
      // Uses the network IP so both physical device and emulator can connect gracefully.
      // (10.0.2.2 is usually for just the emulator, but LAN IP handles both)
      return 'http://10.31.17.178:5002/blueprint';
    }
    return 'http://127.0.0.1:5002/blueprint';
  }

  Future<void> _generateBlueprint() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse(_getBackendUrl()),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'landsize': widget.landsize,
              'floors': widget.floors,
              'bedrooms': widget.bedrooms,
              'bathrooms': widget.bathrooms,
              'kitchen': widget.kitchen,
              'living_room': widget.livingRoom,
              'style': widget.style,
            }),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () =>
                throw Exception('Request timeout - backend may be unavailable'),
          );

      if (response.statusCode == 200) {
        setState(() {
          _generatedBlueprintImage = response.bodyBytes;
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Blueprint generated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'Failed to generate blueprint');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _downloadBlueprint() async {
    if (_generatedBlueprintImage == null) return;

    try {
      await FileSaver.instance.saveFile(
        name: 'archisri_blueprint_${DateTime.now().millisecondsSinceEpoch}.png',
        bytes: _generatedBlueprintImage!,
        mimeType: MimeType.png,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Blueprint downloaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openFullImagePreview() {
    if (_generatedBlueprintImage == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4,
                  child: Center(
                    child: Image.memory(
                      _generatedBlueprintImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _downloadBlueprint();
                      },
                      icon: const Icon(Icons.download, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Calculate dynamic blueprint container height
    final blueprintHeight = (screenHeight * 0.5).clamp(250.0, 600.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5E6D3),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 40,
                top: 60,
                right: 40,
                bottom: 40,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFD4C55A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE68C46),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    padding: const EdgeInsets.all(10),

                    child: Image.asset(
                      'assets/images/artificial-intelligence.png',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AI House Plan Designer",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Start designing with AI assistance",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white70,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          "Step ${currentStep.toInt()} of ${totalSteps.toInt()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: currentStep / totalSteps,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AI - Generated Plan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Foundation recommendation included",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 15),

                  // The Big Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6CDBF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Placeholder or Generated Blueprint
                        GestureDetector(
                          onTap: _generatedBlueprintImage != null
                              ? _openFullImagePreview
                              : null,
                          child: Container(
                            width: double.infinity,
                            height: blueprintHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4EFE6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: _generatedBlueprintImage != null
                                  ? Image.memory(
                                      _generatedBlueprintImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Image.asset(
                                        'assets/blueprint_placeholder.png',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.architecture,
                                                    size: 80,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Title and Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.style} ${widget.floors}-Floor Design",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "${widget.landsize} sq ft",
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _generateBlueprint,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE2AE62),
                                    disabledBackgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          "Regenerate",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Color(0xFF8B4513),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed:
                                      _generatedBlueprintImage == null ||
                                          _isLoading
                                      ? null
                                      : _downloadBlueprint,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCAA070),
                                    disabledBackgroundColor: Colors.grey,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Icon(Icons.download, size: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  //funnadation recomendation part
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7E2B4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black12, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                "Foundation Analyst\nBased on IoT Feedback",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA5D6B6),
                                foregroundColor: Colors.black87,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                "View feedback",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Recommendation Type Row
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Recommendation Type",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD3A278),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                "Raft Foundation",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Cement Type Row
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.deepOrange,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                "Cement Type",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD3A278),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                "OPC 43",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Go to Market Place Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IoTMarketplace(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE2AE62),
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Go To The Market Place",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //explore more section
                  const SizedBox(height: 25),
                  const Text(
                    "Explore More",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      // Construction Companies Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2C4A2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD6AB75),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.domain_add,
                                    color: Colors.black87,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Connect with\nConstruction\nCompanies",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 1.2,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Engineers Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EngineerHomeScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2C4A2),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD6AB75),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Icon(
                                    Icons.engineering,
                                    color: Colors.black87,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  "Engineers\nGet feedback\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    height: 1.2,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // start new design part
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainContentPart(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB5BD55),
                          foregroundColor: Colors.black87,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Start New Design",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.auto_awesome, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

