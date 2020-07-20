import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/viewmodels/views/login_viewmodel.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
// import 'package:flutter_kakao_login/flutter_kakao_login.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Text('no user'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Yes User'),
                  FlatButton(
                      onPressed: () async {
                        FlutterKakaoLogin kakaoSignIn = new FlutterKakaoLogin();
                        final KakaoLoginResult result =
                            await kakaoSignIn.logIn();
                        //print("HELLO");
                        //Provider.of<LoginViewModel>(context, listen: false)
                        //    .handleKaKaoSignIn();
                        //loginButtonClicked();
                        //Navigator.pushReplacementNamed(context, RoutePaths.Home);
                      },
                      color: Colors.yellowAccent,
                      child: Text('카카오로 로그인'))
                ],
              ),
            ),
          );
        }
      },
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [gradientStart, backgroundColor])),
//           child: Center(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Login View'),
//               GoogleSignInButton(
//                 onPressed: () {
//                   Provider.of<LoginViewModel>(context, listen: false)
//                       .handlgeGoogleSignIn();
//                   // .then((FirebaseUser user) => print(user))
//                   // .catchError((e) => print(e));
//                 },
//                 textStyle: TextStyle(fontSize: 15),
//               ),
//               FacebookSignInButton(
//                 onPressed: () async {
//                   Provider.of<LoginViewModel>(context, listen: false)
//                       .handleFacebookSignIn();
// //                _handleFacebookSingIn();
//                 },
//                 text: "Sign in with Facebook",
//                 textStyle: TextStyle(fontSize: 15, color: Colors.white),
//               ),
//               AppleSignInButton(
//                 onPressed: () {},
//                 style: AppleButtonStyle.black,
//                 textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                 ),
//               ),
//               FlatButton(
//                   onPressed: () {
//                     //print('DAFDSA');
//                     Provider.of<LoginViewModel>(context, listen: false)
//                         .handleKaKaoSignIn();
//                     //loginButtonClicked();
//                     //Navigator.pushReplacementNamed(context, RoutePaths.Home);
//                   },
//                   color: Colors.yellowAccent,
//                   child: Text('카카오로 로그인'))
//             ],
//           )),
//         ),
//       ),
    );
  }
}
