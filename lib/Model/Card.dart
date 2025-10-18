import 'package:flutter/material.dart';

// A reusable game card widget styled to match the provided screenshot,
// with detailed parameters for precise styling control.
class GameCard extends StatelessWidget {
  final String title;
  final Gradient titleGradient;
  final String subtitle;
  final Gradient subtitleGradient;
  final String description;
  final String entryCoins;
  final Gradient cardBorderGradient;
  final IconData leadingIcon;
  final Color leadingIconColor;
  final String? imageUrl;
  final bool showDecorations;
  final bool showBadge;
  final String? badgeText1;
  final String? badgeText2;
  final double scale;
  final VoidCallback? onTap;

  const GameCard({
    Key? key,
    required this.title,
    required this.titleGradient,
    required this.subtitle,
    required this.subtitleGradient,
    required this.description,
    required this.entryCoins,
    required this.cardBorderGradient,
    required this.leadingIcon,
    required this.leadingIconColor,
    this.imageUrl,
    this.showDecorations = false,
    this.showBadge = false,
    this.badgeText1,
    this.badgeText2,
    this.scale = 1.0,
    this.onTap,
  }) : super(key: key);

  // Helper widget to create gradient text easily
  Widget _buildGradientText(
    String text,
    Gradient gradient,
    double fontSize,
    FontWeight fontWeight,
  ) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize * scale,
            fontWeight: fontWeight,
            fontFamily: "Host_Grotesk", // Assuming custom font
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is the outer container that creates the gradient border.
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(3.0 * scale),
          decoration: BoxDecoration(
            gradient: cardBorderGradient,
            borderRadius: BorderRadius.circular(20.0 * scale),
          ),
          // This is the inner container with the main content.
          child: Container(
            padding: EdgeInsets.all(16.0 * scale),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff0E0A25),
                  const Color(0xff0E0A25),
                  const Color(0xff2A3A68),
                ],
              ), // The dark inner background
              borderRadius: BorderRadius.circular(18.0 * scale),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon(leadingIcon, color: leadingIconColor, size: 24),
                        SizedBox(width: 15 * scale),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show decorations (hearts/sparkles) if enabled
                            if (showDecorations)
                              Row(
                                children: [
                                  Text('💕', style: TextStyle(fontSize: 20 * scale)),
                                  SizedBox(width: 5 * scale),
                                  _buildGradientText(
                                    title,
                                    titleGradient,
                                    24,
                                    FontWeight.w700,
                                  ),
                                  SizedBox(width: 5 * scale),
                                  Text('❤️', style: TextStyle(fontSize: 20 * scale)),
                                ],
                              )
                            else
                              _buildGradientText(
                                title,
                                titleGradient,
                                24,
                                FontWeight.w700,
                              ),
                            Row(
                              children: [
                                if (showDecorations)
                                  Text('✨', style: TextStyle(fontSize: 18 * scale)),
                                if (showDecorations) SizedBox(width: 5 * scale),
                                _buildGradientText(
                                  subtitle,
                                  subtitleGradient,
                                  32,
                                  FontWeight.w700,
                                ),
                                if (showDecorations) SizedBox(width: 5 * scale),
                                if (showDecorations)
                                  Text('✨', style: TextStyle(fontSize: 18 * scale)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10 * scale),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22 * scale),
                  child: Text(
                    description,
                    style: TextStyle(
                      color: Color(0xff4AFB5E),
                      fontSize: 20 * scale,
                      fontFamily: "Host_Grotesk",
                    ),
                  ),
                ),
                SizedBox(height: 16 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Entry Coins Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22 * scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Entry Coins",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25 * scale,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: "Host_Grotesk",
                            ),
                          ),
                          SizedBox(height: 7 * scale),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10 * scale,
                              vertical: 5 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF203B86),
                              borderRadius: BorderRadius.circular(6 * scale),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/Coin.png',
                                  width: 20 * scale,
                                  height: 20 * scale,
                                ),
                                SizedBox(width: 8 * scale),
                                Text(
                                  entryCoins,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * scale,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: "Host_Grotesk",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Play Now Button with optional badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: SizedBox(
                            width: 135 * scale,
                            height: 51 * scale,
                            child: Image.asset('assets/playnow.png'),
                          ),
                        ),
                        // Badge overlay (for second card)
                        if (showBadge && badgeText1 != null)
                          Positioned(
                            top: -10 * scale,
                            left: -40 * scale,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8 * scale,
                                vertical: 4 * scale,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E88E5),
                                borderRadius: BorderRadius.circular(4 * scale),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    badgeText1!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14 * scale,
                                      fontFamily: "Host_Grotesk",
                                    ),
                                  ),
                                  if (badgeText2 != null)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 16 * scale,
                                          height: 16 * scale,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '!',
                                              style: TextStyle(
                                                color: Color(0xFF1E88E5),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12 * scale,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 4 * scale),
                                        Text(
                                          badgeText2!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14 * scale,
                                            fontFamily: "Host_Grotesk",
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (imageUrl != null) _buildGameImage(),
      ],
    );
  }

  Widget _buildGameImage() {
    switch (imageUrl) {
      case 'assets/ludo1.png':
        return Positioned(
          top: 0,
          right: 5 * scale,
          child: SizedBox(
            height: 200 * scale,
            width: 200 * scale,
            child: Image.asset(imageUrl!),
          ),
        );

      case 'assets/ludo2.png':
        return Positioned(
          top: 0,
          right: 10 * scale,
          child: SizedBox(
            height: 180 * scale,
            width: 180 * scale,
            child: Image.asset(imageUrl!),
          ),
        );

      default:
        return Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            height: 150 * scale,
            width: 150 * scale,
            child: Image.asset(imageUrl!),
          ),
        );
    }
  }
}
