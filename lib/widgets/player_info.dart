import 'package:flutter/material.dart';
import 'package:ludo_app/model/ludo_game.dart';
import '../Model/Responsive.dart';

class PlayerInfo extends StatelessWidget {
  final Player player;
  final bool isCurrentPlayer;
  final int diceValue;
  final double? scale;

  const PlayerInfo({
    super.key,
    required this.player,
    this.isCurrentPlayer = false,
    this.diceValue = 0,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = this.scale ?? responsive.scale;
    
    return Container(
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: isCurrentPlayer
            ? Colors.blue.withAlpha((255 * 0.2).round())
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12 * scale),
        border: isCurrentPlayer
            ? Border.all(color: Colors.blue, width: 2 * scale)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Player avatar
          CircleAvatar(
            radius: 25 * scale,
            backgroundColor: _getColorFromPlayerColor(player.color),
            child: Text(
              player.name[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18 * scale,
              ),
            ),
          ),

          SizedBox(width: 12 * scale),

          // Player name and coins
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * scale,
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/Coin.png', 
                    width: 16 * scale, 
                    height: 16 * scale,
                  ),
                  SizedBox(width: 4 * scale),
                  Text(
                    '${player.coins}',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * scale,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(width: 12 * scale),

          // Dice or status
          if (isCurrentPlayer && diceValue > 0)
            Container(
              width: 40 * scale,
              height: 40 * scale,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8 * scale),
                border: Border.all(color: Colors.blue, width: 2 * scale),
              ),
              child: Center(
                child: Text(
                  '$diceValue',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18 * scale,
                  ),
                ),
              ),
            )
          else if (isCurrentPlayer)
            Container(
              width: 40 * scale,
              height: 40 * scale,
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha((255 * 0.3).round()),
                borderRadius: BorderRadius.circular(8 * scale),
                border: Border.all(color: Colors.blue, width: 2 * scale),
              ),
              child: Icon(
                Icons.play_arrow, 
                color: Colors.blue, 
                size: 20 * scale,
              ),
            )
          else
            Container(
              width: 40 * scale,
              height: 40 * scale,
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha((255 * 0.3).round()),
                borderRadius: BorderRadius.circular(8 * scale),
                border: Border.all(color: Colors.grey, width: 2 * scale),
              ),
              child: Icon(
                Icons.pause, 
                color: Colors.grey, 
                size: 20 * scale,
              ),
            ),
        ],
      ),
    );
  }

  Color _getColorFromPlayerColor(PlayerColor color) {
    switch (color) {
      case PlayerColor.red:
        return Colors.red;
      case PlayerColor.green:
        return Colors.green;
      case PlayerColor.blue:
        return Colors.blue;
      case PlayerColor.yellow:
        return Colors.yellow;
    }
  }
}


