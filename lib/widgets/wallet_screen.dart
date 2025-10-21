import 'package:flutter/material.dart';
import '../Model/Responsive.dart';

class WalletScreen extends StatefulWidget {
  final int currentCoins;
  final Function(int) onCoinsUpdated;

  const WalletScreen({
    super.key,
    required this.currentCoins,
    required this.onCoinsUpdated,
  });

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _currentCoins = 0;

  @override
  void initState() {
    super.initState();
    _currentCoins = widget.currentCoins;
  }

  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    return Scaffold(
      backgroundColor: Color(0xFF1A237E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24 * scale),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Wallet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20 * scale,
            fontWeight: FontWeight.bold,
            fontFamily: "Host_Grotesk",
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16 * scale),
            child: Column(
              children: [
                // Wallet Balance Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24 * scale),
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
                        color: Colors.black.withAlpha((255 * 0.3).round()),
                        blurRadius: 10 * scale,
                        offset: Offset(0, 4 * scale),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Host_Grotesk",
                        ),
                      ),
                      SizedBox(height: 12 * scale),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Coin.png',
                            width: 32 * scale,
                            height: 32 * scale,
                          ),
                          SizedBox(width: 12 * scale),
                          Text(
                            '$_currentCoins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36 * scale,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Host_Grotesk",
                            ),
                          ),
                          Text(
                            ' Coins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18 * scale,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Host_Grotesk",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32 * scale),

                // Add Coins Section
                Text(
                  'Add Coins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22 * scale,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Host_Grotesk",
                  ),
                ),

                SizedBox(height: 20 * scale),

                // Coin Packages
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16 * scale,
                      mainAxisSpacing: 16 * scale,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _coinPackages.length,
                    itemBuilder: (context, index) {
                      final package = _coinPackages[index];
                      return _buildCoinPackage(package, scale);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoinPackage(CoinPackage package, double scale) {
    return GestureDetector(
      onTap: () => _showPaymentModal(package),
      child: Container(
        padding: EdgeInsets.all(16 * scale),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A3A68),
              Color(0xFF1A237E),
            ],
          ),
          borderRadius: BorderRadius.circular(16 * scale),
          border: Border.all(
            color: package.isPopular ? Color(0xFFF9C846) : Colors.transparent,
            width: 2 * scale,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.2).round()),
              blurRadius: 8 * scale,
              offset: Offset(0, 2 * scale),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (package.isPopular)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 4 * scale),
                decoration: BoxDecoration(
                  color: Color(0xFFF9C846),
                  borderRadius: BorderRadius.circular(12 * scale),
                ),
                child: Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10 * scale,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Host_Grotesk",
                  ),
                ),
              ),
            if (package.isPopular) SizedBox(height: 8 * scale),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Coin.png',
                  width: 24 * scale,
                  height: 24 * scale,
                ),
                SizedBox(width: 8 * scale),
                Text(
                  '${package.coins}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Host_Grotesk",
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8 * scale),
            
            Text(
              '₹${package.price}',
              style: TextStyle(
                color: Color(0xFFF9C846),
                fontSize: 18 * scale,
                fontWeight: FontWeight.bold,
                fontFamily: "Host_Grotesk",
              ),
            ),
            
            if (package.bonus > 0)
              Text(
                '+${package.bonus} Bonus',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12 * scale,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Host_Grotesk",
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPaymentModal(CoinPackage package) {
    Responsive responsive = Responsive(context);
    double scale = responsive.scale;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Color(0xFF1A237E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20 * scale),
            topRight: Radius.circular(20 * scale),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24 * scale),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40 * scale,
                height: 4 * scale,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.3).round()),
                  borderRadius: BorderRadius.circular(2 * scale),
                ),
              ),
              
              SizedBox(height: 24 * scale),
              
              // Package details
              Container(
                padding: EdgeInsets.all(20 * scale),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF9C846),
                      Color(0xFFE19E2E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16 * scale),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Coin.png',
                          width: 32 * scale,
                          height: 32 * scale,
                        ),
                        SizedBox(width: 12 * scale),
                        Text(
                          '${package.coins}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32 * scale,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Host_Grotesk",
                          ),
                        ),
                        Text(
                          ' Coins',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Host_Grotesk",
                          ),
                        ),
                      ],
                    ),
                    if (package.bonus > 0) ...[
                      SizedBox(height: 8 * scale),
                      Text(
                        '+${package.bonus} Bonus Coins',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16 * scale,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Host_Grotesk",
                        ),
                      ),
                    ],
                    SizedBox(height: 12 * scale),
                    Text(
                      '₹${package.price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24 * scale,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Host_Grotesk",
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32 * scale),
              
              // Payment methods
              Text(
                'Choose Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Host_Grotesk",
                ),
              ),
              
              SizedBox(height: 20 * scale),
              
              // Payment buttons
              _buildPaymentButton(
                'Credit/Debit Card',
                Icons.credit_card,
                () => _processPayment(package, 'card'),
                scale,
              ),
              
              SizedBox(height: 12 * scale),
              
              _buildPaymentButton(
                'UPI',
                Icons.account_balance_wallet,
                () => _processPayment(package, 'upi'),
                scale,
              ),
              
              SizedBox(height: 12 * scale),
              
              _buildPaymentButton(
                'Net Banking',
                Icons.account_balance,
                () => _processPayment(package, 'netbanking'),
                scale,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton(String title, IconData icon, VoidCallback onTap, double scale) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16 * scale, horizontal: 20 * scale),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((255 * 0.1).round()),
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(color: Colors.white.withAlpha((255 * 0.3).round())),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24 * scale),
            SizedBox(width: 16 * scale),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * scale,
                fontWeight: FontWeight.w500,
                fontFamily: "Host_Grotesk",
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16 * scale),
          ],
        ),
      ),
    );
  }

  void _processPayment(CoinPackage package, String method) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A237E),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFFF9C846)),
            SizedBox(height: 16),
            Text(
              'Processing payment...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _currentCoins += package.coins + package.bonus;
        widget.onCoinsUpdated(_currentCoins);
      });

      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Close payment modal
      Navigator.pop(context); // Close wallet screen

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment successful! ${package.coins + package.bonus} coins added to your wallet.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  final List<CoinPackage> _coinPackages = [
    CoinPackage(coins: 100, price: 10, bonus: 0, isPopular: false),
    CoinPackage(coins: 500, price: 45, bonus: 50, isPopular: true),
    CoinPackage(coins: 1000, price: 80, bonus: 200, isPopular: false),
    CoinPackage(coins: 2500, price: 180, bonus: 750, isPopular: false),
    CoinPackage(coins: 5000, price: 350, bonus: 2000, isPopular: false),
    CoinPackage(coins: 10000, price: 650, bonus: 5000, isPopular: false),
  ];
}

class CoinPackage {
  final int coins;
  final int price;
  final int bonus;
  final bool isPopular;

  CoinPackage({
    required this.coins,
    required this.price,
    required this.bonus,
    required this.isPopular,
  });
}
