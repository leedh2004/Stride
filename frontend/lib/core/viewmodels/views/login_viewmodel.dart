import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:frontend/core/services/authentication_service.dart';
import 'package:frontend/core/viewmodels/base_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// 뷰모델이 비즈니스 로직을 하지말고,
// 로직이 뷰가 없어도 되야할 때, 다른 뷰에서 사용이 되어야할 때로 하자
// 서비스들의 데이터를 가져오는 역할 (변수로 가져온다)

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({@required AuthenticationService authenticationService})
      : _authenticationService = authenticationService;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void handlgeGoogleSignIn() async {
    setBusy(true);
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    _authenticationService.login(user.email);
    setBusy(false);
  }

  void handleFacebookSignIn() async {
    setBusy(true);
    final result = await _facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    _authenticationService.login("${profile['id']}@facebook.com");
    setBusy(false);
  }

  void handleWithoutSignIn() async {
    setBusy(true);
    await Future.delayed(Duration(seconds: 1));
    _authenticationService.login("master@master.com");
    setBusy(false);
  }

  void handleKaKaoSignIn() async {
    try {} catch (e) {}
  }

  void handleAppleSignIn() async {
    try {} catch (e) {}
  }
}
