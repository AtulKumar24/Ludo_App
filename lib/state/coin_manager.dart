import 'package:flutter/foundation.dart';

class CoinManager extends ChangeNotifier {
  static final CoinManager _instance = CoinManager._internal();
  factory CoinManager() => _instance;
  CoinManager._internal();

  int _coins = 20; // Starting coins

  int get coins => _coins;

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setCoins(int amount) {
    _coins = amount;
    notifyListeners();
  }

  void resetCoins() {
    _coins = 20;
    notifyListeners();
  }
}
