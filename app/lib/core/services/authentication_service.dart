import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/user.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class AuthenticationService {
  StreamController<StrideUser> _userController = BehaviorSubject<StrideUser>();
  Stream<StrideUser> get user => _userController.stream;
  FlutterSecureStorage _storage = new FlutterSecureStorage();
  Api api;
  final _firebaseAuth = FirebaseAuth.instance;

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

  Future<bool> loginWithApple({List<Scope> scopes = const []}) async {
    print("!!!");
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        String email = authResult.user.email;
        await _firebaseAuth.signOut();
        return login(email, "apple");

      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  Future<bool> login(String accessToken, String channel) async {
    final response = await api.client.post('${Api.endpoint}/auth/token',
        data:
            jsonEncode({'access_token': accessToken, 'channel': '${channel}'}));

    if (response.statusCode == 200) {
      var parsed = response.data as Map<String, dynamic>;
      var size = jsonDecode(parsed['size']) as Map<String, dynamic>;
      String id = parsed['user_id'];
      String token = parsed['token'];
      print(id);
      print(token);
      // 토큰이 없을 때만 일로 오니까 !
      await _storage.write(key: 'jwt_token', value: token);
      StrideUser user = StrideUser(
          id: id,
          profile_flag: parsed['profile_flag'],
          shoulder: size['shoulder'],
          bust: size['bust'],
          waist: size['waist'],
          hip: size['hip'],
          thigh: size['thigh']);
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: id + '.com', password: "SuperSecretPassword!");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: id + '.com', password: "SuperSecretPassword!");
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
    } else {
      print('Error ${response.statusCode}');
    }
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
        print(response.data);
        var parsed = response.data as Map<String, dynamic>;
        var id = parsed['user_id'];
        print(parsed['size']);
        var size = jsonDecode(parsed['size']) as Map<String, dynamic>;
        StrideUser user = StrideUser(
            id: id,
            profile_flag: parsed['profile_flag'],
            shoulder: size['shoulder'],
            bust: size['bust'],
            waist: size['waist'],
            hip: size['hip'],
            thigh: size['thigh']);
        //뉴토큰으로 토큰 교체해줘야함.
        await _storage.delete(key: 'jwt_token');
        await _storage.write(key: 'jwt_token', value: response.data['token']);
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: id + '.com', password: "SuperSecretPassword!");
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
