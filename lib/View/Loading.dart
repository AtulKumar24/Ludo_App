import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ludo_app/Model/Responsive.dart';

// Replace your existing file content with this full file.

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

// ✅ FIX: Changed to TickerProviderStateMixin to handle multiple controllers.
class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _c2; // Re-introduced the second controller

  @override
  void initState() {
    super.initState();

    // Controller for the circular (background) animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    // Controller for the linear progress bar (with a different duration)
    _c2 = AnimationController(
        duration: const Duration(seconds: 5),
        vsync: this
    )..repeat();

  Future.delayed(Duration(seconds: 5) , (){
    Navigator.pushNamed(context, '/opp');
  });
  }


  @override
  void dispose() {
    _controller.dispose();
    _c2.dispose(); // Dispose both controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/ludobg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Blur + semi-transparent overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: const Color(0xff386BE4).withOpacity(0.45),
              ),
            ),
          ),

          // Decorative assets
          Positioned(
            bottom: 333 * scale,
            right: 159 * scale,
            child: Image.asset(
              'assets/cp.png',
              width: 100 * scale,
              height: 100 * scale,
            ),
          ),

          // Circular custom loader (uses _controller)
          Positioned(
            bottom: 230 * scale,
            right: 55 * scale,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(300 * scale, 300 * scale),
                  painter: CircularLoaderPainter(_controller.value, scale),
                );
              },
            ),
          ),

          Positioned(
            top: 105 * scale,
            left: 110 * scale,
            child: Image.asset(
              'assets/ludoicon.png',
              width: 150 * scale,
              height: 150 * scale,
            ),
          ),
          Positioned(
            top: 360 * scale,
            left: 30 * scale,
            child: Image.asset(
              'assets/p1.png',
              width: 80 * scale,
              height: 80 * scale,
            ),
          ),
          Positioned(
            top: 320 * scale,
            right: 30 * scale,
            child: Image.asset(
              'assets/p2.png',
              width: 80 * scale,
              height: 80 * scale,
            ),
          ),
          Positioned(
            top: 660 * scale,
            left: 60 * scale,
            child: Image.asset(
              'assets/p34.png',
              width: 100 * scale,
              height: 100 * scale,
            ),
          ),
          Positioned(
            bottom: 215 * scale,
            right: 30 * scale,
            child: Image.asset(
              'assets/p4.png',
              width: 80 * scale,
              height: 80 * scale,
            ),
          ),

          // Bottom section: Loading text + working progress bar
          Positioned(
            bottom: 60 * scale,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36 * scale,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(0, 3 * scale),
                        blurRadius: 6 * scale,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20 * scale),

                // Progress bar area
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25 * scale),
                  child: Container(
                    height: 44 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26 * scale),
                      border: Border.all(color: Colors.white, width: 4 * scale),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10 * scale,
                          offset: Offset(0, 4 * scale),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22 * scale),
                      // ✅ FIX: This AnimatedBuilder now correctly listens to _c2.
                      child: AnimatedBuilder(
                        animation: _c2,
                        builder: (context, child) {
                          final progress = _c2.value;
                          return Stack(
                            children: [
                              // 1. Background bar
                              Container(color: const Color(0xFF1A1A1A)),

                              // 2. Animated progress fill
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF00CED1),
                                        Color(0xFF1E90FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                              ),

                              // 3. The moving "shine" effect over the whole bar
                              Positioned.fill(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final barWidth = constraints.maxWidth;
                                    final shineWidth = barWidth * 0.4; // Width of the shine
                                    final left = -shineWidth + (progress * (barWidth + shineWidth));

                                    return Transform.translate(
                                      offset: Offset(left, 0),
                                      child: Container(
                                        width: shineWidth,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Colors.white.withOpacity(0.0),
                                              Colors.white.withOpacity(0.3),
                                              Colors.white.withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // 4. Static stripe overlay on top
                              CustomPaint(
                                  size: Size.infinite,
                                  painter: StripePainter(scale)
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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

class CircularLoaderPainter extends CustomPainter {
  final double animationValue;
  final double scale;

  CircularLoaderPainter(this.animationValue, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;

    for (int i = 0; i < 6; i++) {
      final progress = (animationValue + (i * 0.12)) % 1.0;
      final opacity = (1.0 - progress * 2).clamp(0.0, 1.0); // Fades out faster
      paint.color = Colors.white.withOpacity(opacity);

      final baseRadius = (60.0 + (i * 20.0)) * scale;
      final expandedRadius = baseRadius + (progress * 40 * scale); // Expands further

      canvas.drawCircle(center, expandedRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CircularLoaderPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.scale != scale;
  }
}

class StripePainter extends CustomPainter {
  final double scale;

  StripePainter(this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2) // Darker for better contrast
      ..strokeWidth = 8 * scale
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width + size.height; i += 18 * scale) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height), // Reversed angle
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

