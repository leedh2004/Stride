import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/user.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class AuthenticationService {
  BehaviorSubject<StrideUser> userController = BehaviorSubject<StrideUser>();
  Stream<StrideUser> get user => userController.stream;
  FlutterSecureStorage storage = new FlutterSecureStorage();
  bool init = false;
  Api api;
  final _firebaseAuth = FirebaseAuth.instance;

  AuthenticationService(Api apiService) {
    print("AuthenticationService 생성!!");
    api = apiService;
  }

  changeUserSize(List<RangeWrapper> ranges, List<FlagWrapper> flags) {
    StrideUser user = userController.value;
    List waistRange =
        flags[0].value ? [ranges[0].value.start, ranges[0].value.end] : null;
    List hipRange =
        flags[1].value ? [ranges[1].value.start, ranges[1].value.end] : null;
    ;
    List thighRange =
        flags[2].value ? [ranges[2].value.start, ranges[2].value.end] : null;
    ;
    List shoulderRange =
        flags[3].value ? [ranges[3].value.start, ranges[3].value.end] : null;
    ;
    List bustRange =
        flags[4].value ? [ranges[4].value.start, ranges[4].value.end] : null;
    ;
    user.waist = waistRange;
    user.hip = hipRange;
    user.thigh = thighRange;
    user.shoulder = shoulderRange;
    user.bust = bustRange;
  }

  Future logout() async {
    await storage.delete(key: 'jwt_token');
    userController.add(null); // 이게 맞나..?
    await _firebaseAuth.signOut();
    print('?');
  }

  Future tutorialPass() async {
    StrideUser cur = userController.value;
    StrideUser testuser = new StrideUser.clone(cur);
    testuser.profile_flag = true;
    userController.add(testuser);
  }

  Future<bool> loginWithApple({List<Scope> scopes = const []}) async {
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
        api.errorCreate(Error());
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
    try {
      final response = await api.client.post('${Api.endpoint}/auth/token',
          data: jsonEncode(
              {'access_token': accessToken, 'channel': '${channel}'}));
      var parsed = response.data as Map<String, dynamic>;
      var size = jsonDecode(parsed['size']) as Map<String, dynamic>;
      String id = parsed['user_id'];
      String token = parsed['token'];
      // 토큰이 없을 때만 일로 오니까 !
      await storage.write(key: 'jwt_token', value: token);
      StrideUser user = StrideUser(
          id: id,
          profile_flag: parsed['profile_flag'],
          shoulder: size['shoulder'],
          bust: size['bust'],
          waist: size['waist'],
          hip: size['hip'],
          thigh: size['thigh']);
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: id, password: "SuperSecretPassword!");
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        if (e.code == 'email-already-in-use') {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: id, password: "SuperSecretPassword!");
        }
      } catch (e) {
        print(e.toString());
      }
      userController.add(user);
      api.client.options.headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': "Bearer ${token}",
      };
      print('헤더 붙임!');
    } catch (e) {
      api.errorCreate(Error());
    }
  }

  //예외적으로 try, catch 구문을 쓰지 않음.
  Future checkToken() async {
    String token = await storage.read(key: 'jwt_token');
    if (token == null) {
      init = true;
      return;
    }
    api.client.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      'Authorization': "Bearer ${token}",
    };
    final response = await api.client.get(
      '${Api.endpoint}/login/token',
    );
    if (response.statusCode == 200) {
      print(response.data);
      var parsed = response.data as Map<String, dynamic>;
      var id = parsed['user_id'];
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
      await storage.delete(key: 'jwt_token');
      await storage.write(key: 'jwt_token', value: response.data['token']);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: id, password: "SuperSecretPassword!");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
      userController.add(user);
    } else {
      await storage.delete(key: 'jwt_token');
      print("토큰이 없거나 만료되었습니다");
    }
    init = true;
  }
}
