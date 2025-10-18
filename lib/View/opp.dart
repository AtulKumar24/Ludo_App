import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ludo_app/Model/Responsive.dart';

class OpponentScreen extends StatefulWidget {
  const OpponentScreen({super.key});

  @override
  State<OpponentScreen> createState() => _OpponentScreenState();
}
class _OpponentScreenState extends State<OpponentScreen> {
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/game');
    });
  }
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
                color: const Color(0xff386BE4).withOpacity(0.45),
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
                  'assets/ludoicon.png', // Main Ludo logo from previous screen
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
        _buildPlayerProfile('Rocky', 'assets/cp.png', scale), // Assuming player 1 asset
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFA500), Color(0xFFFFAB01)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: ShaderMask(

            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Color(0xFFFFA500), Color(0xFFFFAB01)],).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            child: Text(
              'VS',
              style: TextStyle(
                fontSize: 38 * scale,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
              ),
            ),
          ),
        ),
        _buildPlayerProfile('Juliee', 'assets/p1.png', scale), // Assuming player 2 asset
      ],
    );
  }

  // Widget for the dice and timer at the bottom
  Widget _buildDiceTimerSection(double scale) {
    return Column(
      children: [
        Image.asset(
          'assets/dice.png', // You'll need a dice asset
          width: 100 * scale,
          height: 100 * scale,
        ),
         SizedBox(height: 12 * scale),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/clock.png',
              width: 30 * scale,
              height: 30 * scale,
            ),
            SizedBox(width: 6 * scale),
            Text(
              '00:20',
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
