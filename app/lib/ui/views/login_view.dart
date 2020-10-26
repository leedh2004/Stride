import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/core/viewmodels/authentication.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:app/ui/views/base_widget.dart';
import 'package:app/ui/widgets/loading.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

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
    print(authCode);
    AccessTokenResponse token =
        await AuthApi.instance.issueAccessToken(authCode);
    model.login(token.accessToken, "kakao", null);
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
                    'images/intro.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                if (Provider.of<AuthenticationService>(context).init == true)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      height: 250,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            UIHelper.verticalSpaceMedium,
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: '클릭 한번으로 로그인까지 ',
                                  style: TextStyle(fontSize: 16)),
                              TextSpan(
                                  text: '단 3초!',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w700)),
                            ])),
                            Text('간편하게 로그인하세요', style: TextStyle(fontSize: 16)),
                            UIHelper.verticalSpaceMedium,
                            FadeIn(
                              delay: 1,
                              child: SizedBox(
                                width: 300,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () =>
                                      _signInWithKakao(context, model),
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
                          ],
                        ),
                      ),
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
                      'images/intro.jpg',
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
