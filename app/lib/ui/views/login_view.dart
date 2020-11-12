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
import 'package:uuid/uuid.dart';

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

  Future<void> _withoutSignIn(
      BuildContext context, AuthenticationModel model) async {
    var storage = model.authService.storage;
    var uid = await storage.read(key: 'uid');
    if (uid == null) {
      var uuid = Uuid();
      uid = uuid.v4();
      await storage.write(key: 'uid', value: uid);
    }
    model.login(uid, "non_member", "non_member");
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
                  height: MediaQuery.of(context).size.height - 100,
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
                      height: 300,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              height: 16,
                            ),
                            // UIHelper.verticalSpaceMedium,
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: '클릭 한번으로 가입까지 ',
                                  style: TextStyle(fontSize: 12)),
                              TextSpan(
                                  text: '단 3초!',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w700)),
                            ])),
                            Text('간편하게 로그인하세요', style: TextStyle(fontSize: 12)),
                            SizedBox(
                              height: 16,
                            ),
                            // UIHelper.verticalSpaceMedium,
                            FadeIn(
                              delay: 1,
                              child: InkWell(
                                onTap: () => _signInWithKakao(context, model),
                                child: Container(
                                  width: 300,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFD554),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 23),
                                        child: Image.asset(
                                          'assets/kakao.png',
                                          width: 21,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '카카오로 계속하기',
                                        style: TextStyle(
                                          color: Color(0xFF552E19),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            // FadeIn(
                            //   delay: 1,
                            //   child: SizedBox(
                            //     width: 300,
                            //     child: RaisedButton(
                            //       padding: EdgeInsets.all(0),
                            //       onPressed: () =>
                            //           _signInWithKakao(context, model),
                            //       child: Image.asset('images/kakao_login.png'),
                            //     ),
                            //   ),
                            // ),
                            if (configService.isAppleAvailable)
                              SizedBox(
                                height: 16,
                              ),
                            if (configService.isAppleAvailable)
                              FadeIn(
                                delay: 1,
                                child: InkWell(
                                  onTap: () => _signInWithApple(context, model),
                                  child: Container(
                                    width: 300,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF222222),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 23),
                                          child: Image.asset(
                                            'assets/apple.png',
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Apple로 계속하기',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 16,
                            ),
                            // UIHelper.verticalSpaceMedium,
                            FadeIn(
                              delay: 1,
                              child: InkWell(
                                onTap: () => _withoutSignIn(context, model),
                                child: Container(
                                  width: 300,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    // color: Color(0xFF222222),
                                    border: Border.all(
                                      color: Color(0xFFF3F4F8),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '로그인 없이 이용하기',
                                        style: TextStyle(
                                          color: Color(0xFF8569EF),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                            // FadeIn(
                            //   delay: 1,
                            //   child: SizedBox(
                            //     width: 300,
                            //     child: RaisedButton(
                            //       padding: EdgeInsets.all(12),
                            //       onPressed: () =>
                            //           _withoutSignIn(context, model),
                            //       child: Text(
                            //         '로그인 없이 이용하기',
                            //         style:
                            //             TextStyle(fontWeight: FontWeight.w700),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
