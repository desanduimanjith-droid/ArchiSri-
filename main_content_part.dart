import 'package:flutter/material.dart';

// ─── Project Model ───────────────────────────────────────────────
class Project {
  final String name;
  final double percent;
  final String status;
  final Color barColor;
  final String icon;
  final bool aiOptimized;

  const Project({
    required this.name,
    required this.percent,
    required this.status,
    required this.barColor,
    required this.icon,
    this.aiOptimized = false,
  });
}

const List<Project> allProjects = [
  Project(
    name: "Modern Villa",
    percent: 0.75,
    status: "In progress",
    barColor: Color(0xFF22C55E),
    icon: "🏡",
  ),
  Project(
    name: "Eco-friendly House",
    percent: 0.45,
    status: "Planning",
    barColor: Color(0xFFF59E0B),
    icon: "🌱",
  ),
  Project(
    name: "Luxury Villa",
    percent: 0.90,
    status: "Almost done",
    barColor: Color(0xFF06B6D4),
    icon: "🏛️",
    aiOptimized: true,
  ),
  Project(
    name: "Beach Cottage",
    percent: 0.30,
    status: "Planning",
    barColor: Color(0xFFF59E0B),
    icon: "🏖️",
  ),
  Project(
    name: "Mountain Retreat",
    percent: 0.60,
    status: "In progress",
    barColor: Color(0xFF22C55E),
    icon: "⛰️",
    aiOptimized: true,
  ),
  Project(
    name: "Urban Loft",
    percent: 0.15,
    status: "Planning",
    barColor: Color(0xFFF59E0B),
    icon: "🏙️",
  ),
  Project(
    name: "Farm House",
    percent: 0.85,
    status: "Almost done",
    barColor: Color(0xFF06B6D4),
    icon: "🌾",
    aiOptimized: true,
  ),
];

// ─── Main Content Page ───────────────────────────────────────────
class MainContentPart extends StatefulWidget {
  const MainContentPart({super.key});

  @override
  State<MainContentPart> createState() => _MainContentPartState();
}

class _MainContentPartState extends State<MainContentPart> {
  bool showAll = false;
  bool startBuildClicked = false;

  // ── Reset everything back to initial state ──
  void reset() {
    setState(() {
      showAll = false;
      startBuildClicked = false;
    });
  }

  // ── Get the most progressed project for the CTA button ──
  Project get topProject {
    return allProjects.reduce((a, b) => a.percent > b.percent ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final visibleProjects =
        showAll ? allProjects : allProjects.take(3).toList();

    Color backgroundColor = const Color(0xFFEBE4D0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Welcome, Desandu 👋',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        actions: [
          // ── Notification bell with badge ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ── Avatar ──
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD4A574),
              ),
              child: const Center(
                child: Text(
                  'D',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // ─────────────────────────────────────────────────────────
      // ── BODY ──
      // ─────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

              // ── Animated Blueprint Banner ──
              BlueprintBanner(
                onStartBuild: () {
                  setState(() => startBuildClicked = true);
                },
              ),

              // ── Start Build confirmation card ──
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                child: startBuildClicked
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF22C55E).withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('✅', style: TextStyle(fontSize: 18)),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'AI House Plan Designer started! Your plan will be ready in less than 2 minutes.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF166534),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(height: 0),
              ),

              const SizedBox(height: 22),

              // ── Recent Projects Card ──
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title row ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Projects',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E2E),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => showAll = !showAll),
                          child: Text(
                            showAll ? 'Show Less ✕' : 'View All >',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ── Project list ── expands in same page ──
                    AnimatedSize(
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.easeInOut,
                      child: Column(
                        children: visibleProjects
                            .map((p) => ProjectCard(project: p))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Continue CTA Button ──
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Continuing "${topProject.name}"...'),
                      backgroundColor: const Color(0xFFF5A623),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5A623),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF5A623).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Continue "${topProject.name}"  >',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Reset Button ──
              GestureDetector(
                onTap: reset,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.refresh_rounded,
                          color: Color(0xFF9CA3AF), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// ── Animated Blueprint Banner Widget ──────────────────────────────
// ═══════════════════════════════════════════════════════════════════
class BlueprintBanner extends StatefulWidget {
  final VoidCallback onStartBuild;

  const BlueprintBanner({super.key, required this.onStartBuild});

  @override
  State<BlueprintBanner> createState() => _BlueprintBannerState();
}

class _BlueprintBannerState extends State<BlueprintBanner>
    with TickerProviderStateMixin {
  late AnimationController _gridController;
  late AnimationController _drawController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gridController.dispose();
    _drawController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8931D), Color(0xFFF5A623), Color(0xFFF7C948)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5A623).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            // ── Animated blueprint background ──
            AnimatedBuilder(
              animation: Listenable.merge(
                  [_gridController, _drawController, _pulseController]),
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: BlueprintPainter(
                    gridOpacity: 0.07 + (_gridController.value * 0.11),
                    drawProgress: _drawController.value,
                    pulseOpacity: 0.25 + (_pulseController.value * 0.55),
                  ),
                );
              },
            ),

            // ── Content ──
            Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Brain icon
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.4), width: 2),
                    ),
                    child: const Center(
                      child: Text('🧠', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Text + button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI House Plan Designer',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Start designing with AI assistant',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Start Build Button ──
                        GestureDetector(
                          onTap: widget.onStartBuild,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7C948),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Start Build',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E2E),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Takes less than 2 minutes',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            
                          ),
                        ),
                      ],
                    ),
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

// ═══════════════════════════════════════════════════════════════════
// ── Blueprint CustomPainter ────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════
class BlueprintPainter extends CustomPainter {
  final double gridOpacity;
  final double drawProgress;
  final double pulseOpacity;

  BlueprintPainter({
    required this.gridOpacity,
    required this.drawProgress,
    required this.pulseOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ── Grid ──
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(gridOpacity)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ── House outline with draw-on effect ──
    final houseW = 90.0;
    final houseH = 60.0;
    final sx = size.width - houseW - 16;
    final sy = size.height - houseH - 20;

    final housePath = Path()
      ..moveTo(sx, sy + houseH)
      ..lineTo(sx, sy + 24)
      ..lineTo(sx + houseW / 2, sy)
      ..lineTo(sx + houseW, sy + 24)
      ..lineTo(sx + houseW, sy + houseH)
      ..close();

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.28)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.clipRect(
        Rect.fromLTWH(0, 0, size.width * drawProgress, size.height));
    canvas.drawPath(housePath, linePaint);
    canvas.restore();

    // ── Windows ──
    final winPaint = Paint()
      ..color = Colors.white.withOpacity(0.15 + pulseOpacity * 0.08)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(sx + 12, sy + 28, 20, 20), winPaint);
    canvas.drawRect(
        Rect.fromLTWH(sx + houseW - 32, sy + 28, 20, 20), winPaint);

    // ── Door ──
    final doorPaint = Paint()
      ..color = Colors.white.withOpacity(0.2 + pulseOpacity * 0.06)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
        Rect.fromLTWH(sx + houseW / 2 - 9, sy + 30, 18, 28), doorPaint);

    // ── Pulsing corner dots ──
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(pulseOpacity * 0.65)
      ..style = PaintingStyle.fill;

    final dots = [
      Offset(14, 14),
      Offset(size.width - 14, 14),
      Offset(14, size.height - 14),
      Offset(size.width - 14, size.height - 14),
    ];
    for (final d in dots) {
      canvas.drawCircle(d, 3.5, dotPaint);
    }

    // ── Dimension tick marks ──
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(sx, sy + houseH + 6),
        Offset(sx + houseW, sy + houseH + 6), tickPaint);
    canvas.drawLine(
        Offset(sx, sy + houseH + 2), Offset(sx, sy + houseH + 10), tickPaint);
    canvas.drawLine(Offset(sx + houseW, sy + houseH + 2),
        Offset(sx + houseW, sy + houseH + 10), tickPaint);
  }

  @override
  bool shouldRepaint(covariant BlueprintPainter oldDelegate) => true;
}

// ═══════════════════════════════════════════════════════════════════
// ── Project Card Widget ────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════════════
class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final percent = (project.percent * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(project.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2E),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: project.barColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: project.percent,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(project.barColor),
                  ),
                ),
                const SizedBox(height: 7),
                project.aiOptimized
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 9),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'AI Optimized',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        project.status,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
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