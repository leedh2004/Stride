import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/config.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../private_web_view.dart';

class ConfigView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    onTapPrivateInfo(BuildContext context) {
      Stride.analytics.logEvent(name: 'MYPAGE_PRIVATE_BUTTON_CLICKED');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PrivateWebView();
      }));
    }

    onTapLogout(BuildContext context) {
      Stride.analytics.logEvent(name: 'MYPAGE_LOGOUT_BUTTON_CLICKED');
      Provider.of<SwipeService>(context, listen: false).init = false;
      Provider.of<DressRoomService>(context, listen: false).init = false;
      Provider.of<LookBookService>(context, listen: false).init = false;
      Provider.of<AuthenticationService>(context, listen: false).logout();
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            '환경설정',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  '계정설정',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                // SizedBox(
                //   height: 24,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [Text('계정연결')],
                // ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('로그아웃'),
                    InkWell(
                        onTap: () {
                          onTapLogout(context);
                          Navigator.maybePop(context);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset('assets/right.png')))
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Divider(),
                SizedBox(
                  height: 24,
                ),
                Text(
                  '서비스 정보',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('버전정보'),
                    Column(
                      children: [
                        Text(
                          '최신 버전 ${Provider.of<ConfigService>(context).updateVersion}',
                          style: TextStyle(color: Color(0xFF8569EF)),
                        ),
                        Text(
                            '현재 버전 ${Provider.of<ConfigService>(context).currentVersion}'),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [Text('이용약관'), Image.asset('assets/right.png')],
                // ),
                // SizedBox(
                //   height: 24,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('개인정보 처리방침'),
                    InkWell(
                        onTap: () => onTapPrivateInfo(context),
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset('assets/right.png')))
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('오픈소스 라이선스'),
                //     Image.asset('assets/right.png')
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}
