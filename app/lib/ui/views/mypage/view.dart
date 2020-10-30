import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/app_colors.dart';
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

  onTapFeedBack(BuildContext context) {
    Stride.analytics.logEvent(name: 'MYPAGE_FEEDBACK_BUTTON_CLICKED');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FeedbackWebView();
    }));
  }

  onTapHelp(BuildContext context) {
    Stride.analytics.logEvent(name: 'MYPAGE_CONTACT_BUTTON_CLICKED');
    ServiceView.scaffoldKey.currentState.showSnackBar(SnackBar(
      duration: Duration(milliseconds: 1500),
      content: Text('help.stride@gmail.com 으로 문의 부탁드립니다.'),
    ));
  }

  onTapConfig(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ConfigView();
    }));
  }

  onTapSizeButton(BuildContext context) {
    Stride.analytics.logEvent(name: 'MYPAGE_SIZE_BUTTON_CLICKED');
    showMaterialModalBottomSheet(
      isDismissible: true,
      expand: false,
      context: context,
      builder: (_context, controller) => SizeInputDialog(
          Provider.of<AuthenticationService>(_context, listen: false)
              .userController
              .value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(132, 115, 225, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32))),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 96, 0, 0),
                child: Text(
                  '회원님',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 23),
              child: InkWell(
                onTap: () => onTapSizeButton(context),
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 240, 252, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(
                    '내 사이즈 수정하기',
                    style: TextStyle(color: Color(0xFF8569EF)),
                  )),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    myPageListTile('최근에 평가한 아이템', () => onTapRecent(context),
                        backgroundColor),
                    Divider(),
                    myPageListTile(
                        '문의 / 건의하기', () => onTapHelp(context), gradientStart),
                    Divider(),
                    myPageListTile(
                        '앱 설문조사', () => onTapFeedBack(context), gradientStart),
                    Divider(),
                    myPageListTile(
                        '환경설정', () => onTapConfig(context), blueColor),
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
