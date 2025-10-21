import 'package:flutter/material.dart';
import 'package:ludo_app/Model/Responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Model/Card.dart' show GameCard;
import '../Widgets/WalletScreen.dart';
import '../state/coin_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openWallet(BuildContext context, int currentCoins) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalletScreen(
          currentCoins: currentCoins,
          onCoinsUpdated: (newCoins) {
            Provider.of<CoinManager>(context, listen: false).setCoins(newCoins);
          },
        ),
      ),
    );
  }

  void _showInsufficientCoinsDialog(BuildContext context, int requiredCoins, int currentCoins) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A237E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20 * scale),
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/Coin.png',
                width: 24 * scale,
                height: 24 * scale,
              ),
              SizedBox(width: 8 * scale),
              Text(
                'Insufficient Coins',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Host_Grotesk",
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You need $requiredCoins coins to play this game.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16 * scale,
                  fontFamily: "Host_Grotesk",
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                'You currently have $currentCoins coins.',
                style: TextStyle(
                  color: Color(0xFFF9C846),
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Host_Grotesk",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16 * scale,
                  fontFamily: "Host_Grotesk",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _openWallet(context, currentCoins);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF9C846),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
              ),
              child: Text(
                'Add Coins',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Host_Grotesk",
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16 * scale),
            child: SingleChildScrollView(
              // Added SingleChildScrollView to prevent overflow
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle back navigation
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24 * scale,
                        ),
                      ),
                      SizedBox(width: 1 * scale),
                      // Using ShaderMask to apply a gradient to the text
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) =>
                            const LinearGradient(
                              colors: [Color(0xFFF9C846), Color(0xFFE19E2E)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        child: Text(
                          "Challenge & Connect",
                          style: TextStyle(
                            // The text color itself is now white, the gradient provides the color
                            fontSize: 25 * scale,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Host_Grotesk",
                          ),
                        ),
                      ),
                      const Spacer(), // Pushes the icon to the end
                      
                      // Wallet with coin balance
                      Consumer<CoinManager>(
                        builder: (context, coinManager, child) {
                          return GestureDetector(
                            onTap: () => _openWallet(context, coinManager.coins),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12 * scale,
                                vertical: 8 * scale,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFF9C846),
                                    Color(0xFFE19E2E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20 * scale),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4 * scale,
                                    offset: Offset(0, 2 * scale),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/Icons/wallet.svg",
                                    width: 20 * scale,
                                    height: 20 * scale,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6 * scale),
                                  Text(
                                    '${coinManager.coins}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16 * scale,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Host_Grotesk",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * scale),

                  Consumer<CoinManager>(
                    builder: (context, coinManager, child) {
                      return GameCard(
                        title: "Want Her Heart?",
                        subtitle: "Khelo Aur \n   Jeeto!",
                        description:
                            "Win the match to unlock 1:1 audio call at 50% OFF!",
                        entryCoins: "25 Coins",
                        leadingIcon: Icons.favorite,
                        leadingIconColor: Colors.red,
                        titleGradient: LinearGradient(
                          colors: [Color(0xFFF83AB9), Color(0xFFF51114)],
                        ),
                        cardBorderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8437C7), Color(0xFFF7B423)],
                        ),
                        subtitleGradient: LinearGradient(
                          colors: [Color(0xFFFFCC00), Color(0xFFF7B423)],
                        ),
                        imageUrl: 'assets/ludo1.png',
                        scale: scale,
                        onTap: () {
                          if (coinManager.coins >= 25) {
                            coinManager.spendCoins(25);
                            Navigator.pushNamed(context, '/load');
                          } else {
                            _showInsufficientCoinsDialog(context, 25, coinManager.coins);
                          }
                        },
                      );
                    },
                  ),

                  SizedBox(height: 20 * scale),

                  // Second Card Instance - with all arguments filled in
                  Consumer<CoinManager>(
                    builder: (context, coinManager, child) {
                      return GameCard(
                        title: "Jeeto Coins",
                        subtitle: "& Dil Ka \nConnection!",
                        description: "Win & Earn coins plus 50% off on 1:1 call!",
                        entryCoins: "50 Coins",
                        leadingIcon: Icons.monetization_on,
                        leadingIconColor: Colors.green,
                        titleGradient: LinearGradient(
                          colors: [Colors.white, Colors.white],
                        ),
                        subtitleGradient: LinearGradient(
                          colors: [Color(0xFFE07700), Color(0xFFE07700)],
                        ),
                        cardBorderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFF5DD2E), Color(0xFFE49D12)],
                        ),
                        imageUrl: 'assets/ludo2.png',
                        scale: scale,
                        onTap: () {
                          if (coinManager.coins >= 50) {
                            coinManager.spendCoins(50);
                            Navigator.pushNamed(context, '/load');
                          } else {
                            _showInsufficientCoinsDialog(context, 50, coinManager.coins);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
