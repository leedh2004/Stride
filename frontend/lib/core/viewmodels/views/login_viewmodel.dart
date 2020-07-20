import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:frontend/core/viewmodels/base_model.dart';
//import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// import 'package:kakao_flutter_sdk/auth.dart';

class LoginViewModel {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void handlgeGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.email);
    //return user;
  }

  void handleFacebookSignIn() async {
    // FacebookLoginResult result =
    //     await facebookLogin.logIn(['email', 'public_profile']);
    // AuthCredential credential = FacebookAuthProvider.getCredential(
    //     accessToken: result.accessToken.token);
    // AuthResult authResult = await _auth.signInWithCredential(credential);
    // FirebaseUser user = authResult.user;
    final result = await _facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
//    print("${profile}@facebook.com");
    print(profile['id']);
  }

  void handleKaKaoSignIn() async {
    try {
      // String authCode = await AuthCodeClient.instance.request(); // via browser
      // String authCode = await AuthCodeClient.instance.requestWithTalk() // or with KakaoTalk
      // var token = await AuthApi.instance.issueAccessToken(authCode);
      // // print(user.kakaoAccount.email);
      // User user = await UserApi.instance.me();
      // print(user);
      // print(user.kakaoAccount.email);
    } catch (e) {
      // some error happened during the course of user login... deal with it.
    }
  }
}
