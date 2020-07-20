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
    if (email == null) {
      print('email 존재 X');
      await prefs.setString('email', 'leedh2008@naver.com');
    } else {
      print(email);
      User user = User(email: email);
      _userController.add(user);
      //prefs.remove('email');
      //print('email 존재해서 삭제');
    }
  }
}
