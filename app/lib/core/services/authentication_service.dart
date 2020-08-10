import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api.dart';

class AuthenticationService {
  StreamController<User> _userController = StreamController<User>();
  Stream<User> get user => _userController.stream;
  FlutterSecureStorage _storage = new FlutterSecureStorage();
  Api _api;

  AuthenticationService(Api api) {
    print("AuthenticationService 생성!!");
    _api = api;
    checkToken();
  }

  Future logout() async {
    await _storage.delete(key: 'jwt_token');
    _userController.add(null); // 이게 맞나..?
  }

  Future login(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
    User user = User(id: 'test');
    _userController.add(user);
  }

  Future checkToken() async {
    String token = await _storage.read(key: 'jwt_token');
    print("Bearer ${token}");
    final response = await _api.client.get(
      '${Api.endpoint}/login/token',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      //만료안하고 성공
      //여기서 고유 아이디 정보를 받아와야함.
      //뉴토큰으로 토큰 교체해줘야함.
      final responseJson = json.decode(response.body);
      print("!!!!!!!!!!!!");
      print(responseJson['new_token']);
      await _storage.delete(key: 'jwt_token');
      await _storage.write(key: 'jwt_token', value: responseJson['new_token']);
      User user = User(id: 'test');
      _userController.add(user);
    } else {
      //만료해버림
      //404헤더가 아님, 403은 만료됐다.
      await _storage.delete(key: 'jwt_token');
      print(await _storage.read(key: 'jwt_token'));
      print("토큰이 없거나 만료되었습니다");
    }
  }
}
