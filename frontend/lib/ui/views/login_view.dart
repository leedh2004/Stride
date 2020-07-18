import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:kakao_flutter_sdk/auth.dart';
// import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:kakao_flutter_sdk/common.dart';

// KakaoContext.clientId = "${put your native app key here}";

void loginButtonClicked() async {
  try {
    String authCode = await AuthCodeClient.instance.request();
    print('here');
  } on KakaoAuthException catch (e) {
    // some error happened during the course of user login... deal with it.
    print('here2');
    print(e);
  } on KakaoClientException catch (e) {
    //
    print('here3');

    print(e);
  } catch (e) {
    //
    print('here4');

    print(e);
  }
}

class LoginView extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();
  Future<FirebaseUser> _handlgeGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.email);
    return user;
  }

  Future<FirebaseUser> _handleFacebookSingIn() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [gradientStart, backgroundColor])),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login View'),
            GoogleSignInButton(
              onPressed: () {
                _handlgeGoogleSignIn().then((user) {
                  print(user);
                });
              },
              textStyle: TextStyle(fontSize: 15),
            ),
            FacebookSignInButton(
              onPressed: () async {
                FacebookLoginResult result =
                    await facebookLogin.logIn(['email', 'public_profile']);
                // AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);
                // AuthResult authResult = await _auth.signInWithCredential(credential);
                // FirebaseUser user = authResult.user;
              },
              text: "Sign in with Facebook",
              textStyle: TextStyle(fontSize: 15, color: Colors.white),
            ),
            AppleSignInButton(
              onPressed: () {},
              style: AppleButtonStyle.black,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            FlatButton(
                onPressed: () {
                  print('DAFDSA');
                  loginButtonClicked();
                  //Navigator.pushReplacementNamed(context, RoutePaths.Home);
                },
                color: Colors.blue,
                child: Text('Go to Home'))
          ],
        )),
      ),
    );
  }
}
