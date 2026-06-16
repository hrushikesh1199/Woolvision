// lib/services/app_provider.dart
import 'package:flutter/foundation.dart';
import '../models/wool_data.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  WoolData _woolData = WoolData.generate();
  String _userName = 'Hrishi';

  bool get isLoggedIn => _isLoggedIn;
  WoolData get woolData => _woolData;
  String get userName => _userName;

  bool login(String email, String password) {
    if (email.trim() == 'hrishi@gmail.com' && password == '123') {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void refreshData() {
    _woolData = WoolData.generate();
    notifyListeners();
  }
}
