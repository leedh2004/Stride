import 'dart:async';
import 'package:app/core/models/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class AuthenticationService {
  StreamController<StrideUser> _userController = BehaviorSubject<StrideUser>();
  Stream<StrideUser> get user => _userController.stream;
  FlutterSecureStorage _storage = new FlutterSecureStorage();
  Api api;

  AuthenticationService(Api apiService) {
    print("AuthenticationService 생성!!");
    api = apiService;
    checkToken();
  }

  Future logout() async {
    await _storage.delete(key: 'jwt_token');
    await _userController.add(null); // 이게 맞나..?
    print('?');
  }

  Future login(String token, String id) async {
    await _storage.write(key: 'jwt_token', value: token);
    StrideUser user = StrideUser(id: id);
    try {
      print("WTFFFFF!");
      print(id);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: id + '.com', password: "SuperSecretPassword!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
    _userController.add(user);
    api.client.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer ${token}",
    };
    print('헤더 붙임!');
  }

  Future checkToken() async {
    String token = await _storage.read(key: 'jwt_token');
    print("checkToken()");
    print("Bearer ${token}");
    try {
      api.client.options.headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': "Bearer ${token}",
      };
      final response = await api.client.get(
        '${Api.endpoint}/login/token',
      );
      // print(response.data);
      if (response.statusCode == 200) {
        var Id = response.data['user_id'];
        print("WTFF!!");
        print(Id);
        //뉴토큰으로 토큰 교체해줘야함.
        await _storage.delete(key: 'jwt_token');
        await _storage.write(
            key: 'jwt_token', value: response.data['new_token']);
        StrideUser user = StrideUser(id: Id);
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: Id + '.com', password: "SuperSecretPassword!");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
        _userController.add(user);
      } else {
        // 404, 403
        await _storage.delete(key: 'jwt_token');
        print(await _storage.read(key: 'jwt_token'));
        print("토큰이 없거나 만료되었습니다");
      }
    } on DioError catch (e) {
      print(e.response.statusCode);
      print("에러!!");
    }
    print("END");
  }
}
