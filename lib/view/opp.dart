import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ludo_app/Model/Responsive.dart'; // Make sure this path is correct

class OpponentScreen extends StatefulWidget {
  const OpponentScreen({super.key});

  @override
  State<OpponentScreen> createState() => _OpponentScreenState();
}

class _OpponentScreenState extends State<OpponentScreen> {
  // --- Stopwatch Variables ---
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _displayTime = "00:00:00"; // Initial display

  @override
  void initState() {
    super.initState();

    // 1. Start the visual stopwatch immediately
    _startTimer();

    // 2. Start the 3-second delay to navigate to the game
    Future.delayed(const Duration(seconds: 3), () {
      // Add a 'mounted' check for safety.
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/game');
      }
    });
  }

  @override
  void dispose() {
    // 3. Stop the timer and stopwatch when the screen is removed
    // This is crucial to prevent memory leaks!
    _stopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  // --- Stopwatch Helper Methods ---

  void _startTimer() {
    // Start the stopwatch to begin measuring time
    _stopwatch.start();

    // Start a periodic timer that updates the UI every 30 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      // If the widget is no longer in the tree, stop the timer
      if (!mounted) {
        t.cancel();
        return;
      }

      // Update the state to rebuild the widget with the new time
      setState(() {
        _displayTime = _formatTime(_stopwatch.elapsedMilliseconds);
      });
    });
  }

  String _formatTime(int milliseconds) {
    // Format milliseconds into MM:SS:ss
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr:$hundredsStr";
  }

  // --- Build Method and UI Helpers ---

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/ludobg.png', // Assuming the same background
              fit: BoxFit.cover,
            ),
          ),

          // 2. Blur + semi-transparent overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: const Color(0xff386BE4).withAlpha((255 * 0.45).round()),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Top Ludo Icon
                Image.asset(
                  'assets/ludoicon.png', // Main Ludo logo
                  height: 150 * scale,
                  width: 150 * scale,
                ),

                // Middle "VS" Section
                _buildVersusSection(scale),

                // Bottom Dice and Timer Section
                _buildDiceTimerSection(scale),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the player profile (Avatar + Name)
  Widget _buildPlayerProfile(String name, String imagePath, double scale) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60 * scale,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 12 * scale),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22 * scale,
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
            shadows: [
              Shadow(
                blurRadius: 8.0 * scale,
                color: Colors.black54,
                offset: Offset(2.0 * scale, 2.0 * scale),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for the entire "VS" layout
  Widget _buildVersusSection(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPlayerProfile('Rocky', 'assets/cp.png', scale), // Player 1
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFA500), Color(0xFFFFAB01)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'VS',
            style: TextStyle(
              fontSize: 38 * scale,
              fontWeight: FontWeight.bold,
              fontFamily: "Roboto",
            ),
          ),
        ),
        _buildPlayerProfile('Juliee', 'assets/p1.png', scale), // Player 2
      ],
    );
  }

  // Widget for the dice and timer at the bottom
  Widget _buildDiceTimerSection(double scale) {
    return Column(
      children: [
        Image.asset(
          'assets/dice.png', // Dice asset
          width: 100 * scale,
          height: 100 * scale,
        ),
        SizedBox(height: 12 * scale),
        // Using a Row for better icon-to-text alignment
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/clock.png',
              width: 30 * scale,
              height: 30 * scale,
            ),
            SizedBox(width: 8 * scale), // Spacing
            Text(
              _displayTime, // The timer text
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
              ),
            ),
          ],
        ),
      ],
    );
  }
}