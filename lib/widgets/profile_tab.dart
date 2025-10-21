import 'package:flutter/material.dart';
import '../Model/Responsive.dart';

class ProfileTab extends StatefulWidget {
  final String userName;
  final String opponentName;
  final String userProfileImage;
  final String opponentProfileImage;
  final int userCoins;
  final int opponentCoins;
  final int userDiceValue;
  final int opponentDiceValue;
  final VoidCallback? onEmojiTap;

  const ProfileTab({
    super.key,
    required this.userName,
    required this.opponentName,
    required this.userProfileImage,
    required this.opponentProfileImage,
    required this.userCoins,
    required this.opponentCoins,
    this.userDiceValue = 0,
    this.opponentDiceValue = 0,
    this.onEmojiTap,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded ? null : 80 * scale, // Remove fixed height when expanded
      constraints: _isExpanded ? BoxConstraints(maxHeight: 300 * scale) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1A237E), // Dark blue background like in screenshot
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20 * scale),
            topRight: Radius.circular(20 * scale),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.3).round()),
              blurRadius: 10 * scale,
              offset: Offset(0, -2 * scale),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use minimum size
          children: [
            // Tab header
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                height: 60 * scale,
                padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                child: Row(
                  children: [
                    // User profile (left side)
                    _buildProfileInfo(
                      widget.userName,
                      widget.userProfileImage,
                      widget.userCoins,
                      widget.userDiceValue,
                      scale,
                      isUser: true,
                    ),
                    
                    Spacer(),
                    
                    // Expand/collapse indicator
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 24 * scale,
                    ),
                    
                    Spacer(),
                    
                    // Opponent profile (right side)
                    _buildProfileInfo(
                      widget.opponentName,
                      widget.opponentProfileImage,
                      widget.opponentCoins,
                      widget.opponentDiceValue,
                      scale,
                      isUser: false,
                    ),
                  ],
                ),
              ),
            ),
            
            // Expanded content
            if (_isExpanded)
              Expanded(
                child: Column(
                  children: [
                    // Tab bar
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16 * scale),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(10 * scale),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10 * scale),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: [
                          Tab(text: 'You'),
                          Tab(text: 'Opponent'),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 16 * scale),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUserProfile(scale),
                          _buildOpponentProfile(scale),
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

  Widget _buildProfileInfo(String name, String imagePath, int coins, int diceValue, double scale, {required bool isUser}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile image
        CircleAvatar(
          radius: 20 * scale,
          backgroundImage: AssetImage(imagePath),
        ),
        
        SizedBox(width: 8 * scale),
        
        // Name and info
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/Coin.png',
                  width: 12 * scale,
                  height: 12 * scale,
                ),
                SizedBox(width: 4 * scale),
                Text(
                  '$coins',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 12 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        SizedBox(width: 8 * scale),
        
        // Dice value
        Container(
          width: 30 * scale,
          height: 30 * scale,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8 * scale),
            border: Border.all(color: Colors.white, width: 1 * scale),
          ),
          child: Center(
            child: Text(
              '$diceValue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * scale,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfile(double scale) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // User details
          Row(
            children: [
              CircleAvatar(
                radius: 30 * scale,
                backgroundImage: AssetImage(widget.userProfileImage),
              ),
              SizedBox(width: 16 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8 * scale),
                    Row(
                      children: [
                        Image.asset(
                          'assets/Coin.png',
                          width: 16 * scale,
                          height: 16 * scale,
                        ),
                        SizedBox(width: 8 * scale),
                        Text(
                          '${widget.userCoins} Coins',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      '⚡ Power Up',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpponentProfile(double scale) {
    return Container(
      padding: EdgeInsets.all(16 * scale),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Opponent details
          Row(
            children: [
              CircleAvatar(
                radius: 30 * scale,
                backgroundImage: AssetImage(widget.opponentProfileImage),
              ),
              SizedBox(width: 16 * scale),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.opponentName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18 * scale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8 * scale),
                    Row(
                      children: [
                        Image.asset(
                          'assets/Coin.png',
                          width: 16 * scale,
                          height: 16 * scale,
                        ),
                        SizedBox(width: 8 * scale),
                        Text(
                          '${widget.opponentCoins} Coins',
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 14 * scale,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4 * scale),
                    Text(
                      '⚡ Power Up',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12 * scale,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
