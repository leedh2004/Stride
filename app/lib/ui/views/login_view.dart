import 'dart:convert';

import 'package:app/core/services/authentication_service.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStart, backgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'stride',
                style: whiteHeaderStyle,
              ),
              UIHelper.verticalSpaceMedium,
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KakaoLoginPage()));
                },
                color: Colors.yellow[200],
                child: SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[Text('카카오 로그인')],
                  ),
                ),
              ),
              UIHelper.verticalSpaceMedium,
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NaverLoginPage()));
                },
                color: Colors.green,
                child: SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[Text('네이버 로그인')],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KakaoLoginPage extends StatelessWidget {
  @override
  String redirect_uri = "http://api-stride.com:5000/kakao/oauth";
  String client_id = "ffc1ec82f333d835621df9caa8511e64";
  final storage = new FlutterSecureStorage();

  Widget build(BuildContext context) {
    Stride.analytics.logLogin();

    return Scaffold(
      body: SafeArea(
          child: WebView(
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: 'jwt_token',
              onMessageReceived: (JavascriptMessage msg) async {
                print(msg.message);
                List<String> info = msg.message.split(',');
                Provider.of<AuthenticationService>(context, listen: false)
                    .login(info[0], info[1] + '@' + info[2]);
                Navigator.pop(context);
              })
        ].toSet(),
        initialUrl:
            'https://kauth.kakao.com/oauth/authorize?client_id=${client_id}&redirect_uri=${redirect_uri}&response_type=code',
        javascriptMode: JavascriptMode.unrestricted,
      )),
    );
  }
}

class NaverLoginPage extends StatelessWidget {
  String redirect_url = "http://api-stride.com:5000/naver/oauth";
  String client_id = "5cowST1OYAYIE38vxCq0";
  @override
  Widget build(BuildContext context) {
    Stride.analytics.logLogin();

    return Scaffold(
      body: SafeArea(
          child: WebView(
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: 'jwt_token',
              onMessageReceived: (JavascriptMessage msg) async {
                print("!!");
                print(msg.message);
                List<String> info = msg.message.split(',');
                //await storage.write(key: 'jwt_token', value: msg.message);
                Provider.of<AuthenticationService>(context, listen: false)
                    .login(info[0], info[1] + '@' + info[2]);
                print(info[1]); // id
                print(info[2]); // channel
                Navigator.pop(context);
              })
        ].toSet(),
        initialUrl:
            'https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=${client_id}&redirect_url=${redirect_url}',
        javascriptMode: JavascriptMode.unrestricted,
      )),
    );
  }
}
