import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/core/viewmodels/authentication.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class LoginView extends StatelessWidget {
  Future<void> _signInWithApple(
      BuildContext context, AuthenticationModel model) async {
    try {
      await model.loginWithApple(scopes: [Scope.email, Scope.fullName]);
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  Future<void> _signInWithKakao(
      BuildContext context, AuthenticationModel model) async {
    final installed = await isKakaoTalkInstalled();
    final authCode = installed
        ? await AuthCodeClient.instance.requestWithTalk()
        : await AuthCodeClient.instance.request();
    AccessTokenResponse token =
        await AuthApi.instance.issueAccessToken(authCode);
    model.login(token.accessToken, "kakao");
  }

  @override
  Widget build(BuildContext context) {
    ConfigService configService =
        Provider.of<ConfigService>(context, listen: false);
    Widget showWidget;
    return Scaffold(
      body: BaseWidget<AuthenticationModel>(
        model: AuthenticationModel(Provider.of(context)),
        builder: (context, model, child) {
          if (model.authService.init == true) {
            showWidget = Container(
              child: Stack(children: [
                Container(
                  width: double.infinity,
                  child: Image.asset(
                    'images/intro.png',
                    fit: BoxFit.cover,
                  ),
                ),
                if (Provider.of<AuthenticationService>(context).init == true)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FadeIn(
                          delay: 1,
                          child: SizedBox(
                            width: 300,
                            child: RaisedButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () => _signInWithKakao(context, model),
                              child: Image.asset('images/kakao_login.png'),
                            ),
                          ),
                        ),
                        if (configService.isAppleAvailable)
                          UIHelper.verticalSpaceMedium,
                        if (configService.isAppleAvailable)
                          FadeIn(
                            delay: 1,
                            child: SizedBox(
                              width: 300,
                              child: AppleSignInButton(
                                style: ButtonStyle.black, // style as needed
                                type: ButtonType.signIn, // style as needed
                                onPressed: () =>
                                    _signInWithApple(context, model),
                              ),
                            ),
                          ),
                        UIHelper.verticalSpaceLarge,
                        UIHelper.verticalSpaceLarge,
                      ],
                    ),
                  ),
                if (model.busy) WhiteLoadingWidget()
              ]),
            );
          } else {
            model.init();
            showWidget = Container(
                width: double.infinity,
                child: Stack(children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'images/intro.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ]));
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: showWidget);
        },
      ),
    );
  }
}

// class KakaoLoginPage extends StatelessWidget {
//   @override
//   String redirect_uri = "https://api-stride.com/kakao/oauth";
//   String client_id = "ffc1ec82f333d835621df9caa8511e64";
//   final storage = new FlutterSecureStorage();

//   Widget build(BuildContext context) {
//     Stride.analytics.logLogin();

//     return Scaffold(
//       body: SafeArea(
//           child: WebView(
//         javascriptChannels: <JavascriptChannel>[
//           JavascriptChannel(
//               name: 'jwt_token',
//               onMessageReceived: (JavascriptMessage msg) async {
//                 print(msg.message);
//                 List<String> info = msg.message.split(',');
//                 // print(info);
//                 Provider.of<AuthenticationService>(context, listen: false)
//                     .login(info[0], info[1] + '@' + info[2]);
//                 Navigator.pop(context);
//               })
//         ].toSet(),
//         initialUrl:
//             'https://kauth.kakao.com/oauth/authorize?client_id=${client_id}&redirect_uri=${redirect_uri}&response_type=code',
//         javascriptMode: JavascriptMode.unrestricted,
//       )),
//     );
//   }
// }

// class NaverLoginPage extends StatelessWidget {
//   String redirect_url = "https://api-stride.com/naver/oauth";
//   String client_id = "5cowST1OYAYIE38vxCq0";
//   @override
//   Widget build(BuildContext context) {
//     Stride.analytics.logLogin();

//     return Scaffold(
//       body: SafeArea(
//           child: WebView(
//         javascriptChannels: <JavascriptChannel>[
//           JavascriptChannel(
//               name: 'jwt_token',
//               onMessageReceived: (JavascriptMessage msg) async {
//                 print("!!");
//                 print(msg.message);
//                 // print(info);
//                 List<String> info = msg.message.split(',');
//                 //await storage.write(key: 'jwt_token', value: msg.message);
//                 Provider.of<AuthenticationService>(context, listen: false)
//                     .login(info[0], info[1] + '@' + info[2]);
//                 print(info[1]); // id
//                 print(info[2]); // channel
//                 Navigator.pop(context);
//               })
//         ].toSet(),
//         initialUrl:
//             'https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=${client_id}&redirect_url=${redirect_url}',
//         javascriptMode: JavascriptMode.unrestricted,
//       )),
//     );
//   }
// }
