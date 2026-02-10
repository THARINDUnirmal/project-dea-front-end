import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoProvider extends ChangeNotifier {
  bool _isLogin = false;

  Future<void> isUserLogin() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    int? value = _pref.getInt('userId');
    if (value != null) {
      _isLogin = true;
      notifyListeners();
    } else {
      _isLogin = false;
      notifyListeners();
    }
  }

  void setLoginState({required bool loginValue}) {
    _isLogin = loginValue;
    notifyListeners();
  }

  bool get getLoginState => _isLogin;
}
