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
  StrideUser master;
  bool init = false;
  bool review = false;
  bool onTutorial = false;
  int flush_tutorial = 0;
  bool swipe_tutorial = false;
  // bool swipe_heart_tutorial = false;
  bool dress_tutorial = false;
  bool image_tutorial = false;

  void minusLike() {
    master.like--;
  }

  void minusDislike() {
    master.dislike--;
  }

  void addLike() {
    master.like++;
  }

  void addDislike() {
    master.dislike++;
  }

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
    // await _firebaseAuth.signOut();
    print('?');
  }

  // Future tutorialPass() async {
  //   StrideUser cur = userController.value;
  //   StrideUser testuser = new StrideUser.clone(cur);
  //   testuser.profile_flag = true;
  //   userController.add(testuser);
  // }

  Future<List<String>> loginWithApple({List<Scope> scopes = const []}) async {
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        print('!!!!!!!!NAME@@@@@@@@@');
        // print(
        // '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}');
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        print(authResult);
        String email = authResult.user.email;
        _firebaseAuth.signOut();
        return [
          email,
          '${appleIdCredential.fullName.familyName}${appleIdCredential.fullName.givenName}'
        ];
      // return login(email, "apple");

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

  Future<bool> login(String accessToken, String channel, String name) async {
    print("login()");
    try {
      var response;
      await Future.wait([
        () async {
          response = await api.client.post('${Api.endpoint}/auth/token',
              data: jsonEncode({
                'access_token': accessToken,
                'channel': '${channel}',
                'name': name
              }));
          print('zero');
        }(),
        () async {
          if (await storage.read(key: 'flush_tutorial') != null)
            flush_tutorial = -1;
          print('first');
        }(),
        () async {
          if (await storage.read(key: 'swipe_tutorial') != null)
            swipe_tutorial = true;
          print('second');
        }(),
        () async {
          if (await storage.read(key: 'image_tutorial') != null)
            image_tutorial = true;
          print('three');
        }(),
        () async {
          if (await storage.read(key: 'dress_tutorial') != null)
            dress_tutorial = true;
          print('four');
        }(),
      ]);
      var parsed = response.data as Map<String, dynamic>;
      print(parsed);
      var size = jsonDecode(parsed['size']) as Map<String, dynamic>;
      String id = parsed['user_id'];
      String token = parsed['token'];
      // 토큰이 없을 때만 일로 오니까 !
      print(parsed['name']);
      print("???!!!!!!!!!!ZXCZC");
      var likes = jsonDecode(parsed['likes']) as Map<String, dynamic>;
      storage.write(key: 'jwt_token', value: token);
      StrideUser user = StrideUser(
          id: id,
          like: likes['like'],
          dislike: likes['dislike'],
          profile_flag: parsed['profile_flag'],
          name: parsed['name'],
          shoulder: size['shoulder'],
          bust: size['bust'],
          waist: size['waist'],
          hip: size['hip'],
          thigh: size['thigh']);
      master = user;

      // try {
      //   FirebaseAuth.instance.createUserWithEmailAndPassword(
      //       email: id, password: "SuperSecretPassword!");
      // } on FirebaseAuthException catch (e) {
      //   print(e.toString());
      //   if (e.code == 'email-already-in-use') {
      //     FirebaseAuth.instance.signInWithEmailAndPassword(
      //         email: id, password: "SuperSecretPassword!");
      //   }
      // } catch (e) {
      //   print(e.toString());
      // }

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
    try {
      String token;
      await Future.wait([
        () async {
          token = await storage.read(key: 'jwt_token');
          print("FIRST");
        }(),
        () async {
          if (await storage.read(key: 'flush_tutorial') != null) {
            flush_tutorial = -1;
          }
          print("SECOND");
        }(),
        () async {
          if (await storage.read(key: 'swipe_tutorial') != null)
            swipe_tutorial = true;
          print("THIRD");
        }(),
        () async {
          if (await storage.read(key: 'image_tutorial') != null)
            image_tutorial = true;
          print("FOUR");
        }(),
        () async {
          if (await storage.read(key: 'dress_tutorial') != null)
            dress_tutorial = true;
          print("FIVE");
        }(),
        () async {
          if (await storage.read(key: 'review') != null) review = true;
          print("SIX");
        }()
      ]);

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
        await storage.delete(key: 'jwt_token');
        print(response.data);
        var parsed = response.data as Map<String, dynamic>;
        var id = parsed['user_id'];
        var size = jsonDecode(parsed['size']) as Map<String, dynamic>;
        var likes = jsonDecode(parsed['likes']) as Map<String, dynamic>;
        StrideUser user = StrideUser(
            id: id,
            profile_flag: parsed['profile_flag'],
            name: parsed['name'] != null ? jsonDecode(parsed['name']) : null,
            shoulder: size['shoulder'],
            bust: size['bust'],
            like: likes['like'],
            dislike: likes['dislike'],
            waist: size['waist'],
            hip: size['hip'],
            thigh: size['thigh']);
        master = user;
        userController.add(user);
        await storage.write(key: 'jwt_token', value: response.data['token']);
        // try {
        //   FirebaseAuth.instance.signInWithEmailAndPassword(
        //       email: id, password: "SuperSecretPassword!");
        // } on FirebaseAuthException catch (e) {
        //   if (e.code == 'user-not-found') {
        //     print('No user found for that email.');
        //   } else if (e.code == 'wrong-password') {
        //     print('Wrong password provided for that user.');
        //   }
        //   init = true;
        // }
      } else {
        await storage.delete(key: 'jwt_token');
        print("토큰이 없거나 만료되었습니다");
      }
    } catch (e) {
      print(e.toString());
      init = true;
    }
    init = true;
  }
}
