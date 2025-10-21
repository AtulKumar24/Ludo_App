import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:provider/provider.dart';

import 'model/ludo.dart';
import 'view/home.dart';
import 'view/loading.dart';
import 'view/opp.dart';
import 'model/responsive.dart';
import 'widgets/profile_tab.dart';
import 'widgets/emoji_section.dart';
import 'state/coin_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CoinManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ludo app",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes:{
        '/' : (context) => HomeScreen(),
        '/load' : (context) => Loading(),
        '/opp' : (context) => OpponentScreen(),
        '/game' : (context) =>  SecondScreen(),
      },
    );
  }
}

class SecondScreen extends StatefulWidget {
  final int? selectedPlayerCount = 2;

  const SecondScreen({super.key});

  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  List<String> selectedTeams = [];
  int? selectedOption; // New state variable to track selected radio option

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff002fa7),
              Color(0xff002fa7),
            ],
          ),
        ),
        child: Center(
          child: Builder(
            builder: (context) {
              switch (widget.selectedPlayerCount) {
                case 2:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0 * scale)),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16 * scale,
                                vertical: 12 * scale,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameApp(
                                      selectedTeams: ['BP', 'GP']),
                                ),
                              );
                            }, // Empty onPressed action
                            child: Row(
                              children: [
                                TokenDisplay(color: Colors.blue, scale: scale),
                                SizedBox(width: 4 * scale),
                                Text(
                                  'Player 1',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * scale,
                                  ),
                                ),
                                SizedBox(width: 30 * scale),
                                TokenDisplay(color: Colors.green, scale: scale),
                                SizedBox(width: 4 * scale),
                                Text(
                                  'Player 2',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * scale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20 * scale),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0 * scale)),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16 * scale,
                                vertical: 12 * scale,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const GameApp(
                                      selectedTeams: ['RP', 'YP']),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                TokenDisplay(color: Colors.red, scale: scale),
                                SizedBox(width: 4 * scale),
                                Text(
                                  'Player 1',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * scale,
                                  ),
                                ),
                                SizedBox(width: 30 * scale),
                                TokenDisplay(color: Colors.yellow, scale: scale),
                                SizedBox(width: 4 * scale),
                                Text(
                                  'Player 2',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * scale,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                case 4:
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GameApp(selectedTeams: selectedTeams),
                        ),
                      );
                    },
                    child: Text(
                      '4 Players Selected',
                      style: TextStyle(fontSize: 16 * scale),
                    ),
                  );
                default:
                  return Text(
                    'Invalid Player Count',
                    style: TextStyle(fontSize: 16 * scale),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class GameApp extends StatefulWidget {
  final List<String> selectedTeams;

  const GameApp({super.key, required this.selectedTeams});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  Ludo? game;
  String _selectedEmoji = '';
  int _userDiceValue = 0;
  int _opponentDiceValue = 0;

  @override
  void initState() {
    super.initState();
    game = Ludo(widget.selectedTeams, context); // Initialize game instance
  }

  void _updateDiceValues() {
    // This method can be called when dice values change in the game
    setState(() {
      // Update dice values based on game state
      // For now, using random values as example
      _userDiceValue = (DateTime.now().millisecondsSinceEpoch % 6) + 1;
      _opponentDiceValue = (DateTime.now().millisecondsSinceEpoch % 6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, dynamic) {
        _showExitConfirmationDialog();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFF1A237E), // Dark blue background like in screenshot
          body: Stack(
            children: [
              // Main game area
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1A237E), // Dark blue background
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16 * scale),
                      child: Center(
                        child: FittedBox(
                          child: SizedBox(
                            width: screenWidth,
                            height: screenWidth + screenWidth * 0.70,
                            child: GameWidget(game: game!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Profile tab at the top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: _updateDiceValues, // Tap to update dice values
                    child: ProfileTab(
                      userName: "Anika Jain",
                      opponentName: "Nirmal T...",
                      userProfileImage: "assets/p1.png",
                      opponentProfileImage: "assets/cp.png",
                      userCoins: 20,
                      opponentCoins: 350,
                      userDiceValue: _userDiceValue,
                      opponentDiceValue: _opponentDiceValue,
                    ),
                  ),
                ),
              ),
              
              // Exit button
              Positioned(
                top: 16 * scale,
                right: 16 * scale,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: _showExitConfirmationDialog,
                    child: Container(
                      padding: EdgeInsets.all(8 * scale),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha((255 * 0.8).round()),
                        borderRadius: BorderRadius.circular(20 * scale),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((255 * 0.3).round()),
                            blurRadius: 4 * scale,
                            offset: Offset(0, 2 * scale),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20 * scale,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Emoji section at the bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: EmojiSection(
                  selectedEmojis: _selectedEmoji.isNotEmpty ? [_selectedEmoji] : [],
                  onEmojiSelected: (emoji) {
                    setState(() {
                      _selectedEmoji = emoji;
                    });
                    // Handle emoji selection
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmationDialog() {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Exit Game',
            style: TextStyle(fontSize: 18 * scale),
          ),
          content: Text(
            'Do you really want to exit the game?',
            style: TextStyle(fontSize: 16 * scale),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text(
                'No',
                style: TextStyle(fontSize: 16 * scale),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: Text(
                'Yes',
                style: TextStyle(fontSize: 16 * scale),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TokenDisplay extends StatelessWidget {
  final Color color;
  final double scale;

  const TokenDisplay({super.key, required this.color, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(30 * scale, 30 * scale), // Adjust size as needed
      painter: TokenPainter(
        fillPaint: Paint()..color = color,
        borderPaint: Paint()
          ..color = Colors.black
          ..strokeWidth = 1.0 * scale
          ..style = PaintingStyle.stroke,
      ),
    );
  }
}

class TokenPainter extends CustomPainter {
  final Paint fillPaint;
  final Paint borderPaint;

  TokenPainter({
    required this.fillPaint,
    required this.borderPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outerRadius = size.width / 2;
    final smallerCircleRadius = outerRadius / 1.7;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, outerRadius, Paint()..color = Colors.white);
    canvas.drawCircle(center, outerRadius, borderPaint);
    canvas.drawCircle(center, smallerCircleRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlayArea extends RectangleComponent with HasGameReference<Ludo> {
  PlayArea() : super(children: [RectangleHitbox()]);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}

