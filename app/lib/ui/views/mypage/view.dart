import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/mypage/config.dart';
import 'package:app/ui/views/private_web_view.dart';
import 'package:app/ui/widgets/mypage/input_dialog.dart';
import 'package:app/ui/widgets/mypage/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../feedback_web_view.dart';
import '../recent_item_view.dart';
import '../service_view.dart';

class MyPageView extends StatelessWidget {
  onTapRecent(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecentItemView();
    }));
  }

  onTapFeedBack(BuildContext context) {
    Stride.analytics.logEvent(name: 'MYPAGE_FEEDBACK_BUTTON_CLICKED');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FeedbackWebView();
    }));
  }

  onTapHelp(BuildContext context) {
    Stride.analytics.logEvent(name: 'MYPAGE_CONTACT_BUTTON_CLICKED');
    // ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
    //   duration: Duration(milliseconds: 1500),
    //   content: Text('help.stride@gmail.com 으로 문의 부탁드립니다.'),
    // ));
    help_flush.show(context);
  }

  onTapConfig(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ConfigView();
    }));
  }

  onTapSizeButton(BuildContext context) {
    Stride.analytics.logEvent(name: 'MYPAGE_SIZE_BUTTON_CLICKED');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SizeInputDialog(
          Provider.of<AuthenticationService>(context, listen: false)
              .userController
              .value);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: Text(
            '마이페이지',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
              child: InkWell(
                onTap: () => onTapSizeButton(context),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 240, 252, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '내 사이즈 수정하기',
                          style: TextStyle(color: Color(0xFF8569EF)),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          'assets/name_edit.png',
                          width: 12,
                        )
                      ]),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    myPageListTile('최근에 평가한 아이템', () => onTapRecent(context),
                        "assets/clean-clothes.png"),
                    Divider(),
                    myPageListTile('문의 / 건의하기', () => onTapHelp(context),
                        "assets/email.png"),
                    Divider(),
                    myPageListTile('앱 설문조사', () => onTapFeedBack(context),
                        "assets/chat.png"),
                    Divider(),
                    myPageListTile(
                        '환경설정', () => onTapConfig(context), "assets/gear.png"),
                    //     '개인정보 처리방침', () => onTapPrivateInfo(context), blueColor)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
