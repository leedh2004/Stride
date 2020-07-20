import 'dart:async';
import 'package:frontend/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  StreamController<User> _userController = StreamController<User>();
  Stream<User> get user => _userController.stream;

  AuthenticationService() {
    loginCheck();
  }

  Future loginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    if (email != null) {
      login(email);
    }
  }

  void login(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    User user = User(email: email);
    _userController.add(user);
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    _userController.add(null);
  }
}
