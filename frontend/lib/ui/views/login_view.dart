import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
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
                _handleSignIn().then((user) {
                  print(user);
                });
              },
              textStyle: TextStyle(fontSize: 15),
            ),
            FacebookSignInButton(
              onPressed: () {},
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
                  Navigator.pushReplacementNamed(context, RoutePaths.Home);
                },
                color: Colors.blue,
                child: Text('Go to Home'))
          ],
        )),
      ),
    );
  }
}
