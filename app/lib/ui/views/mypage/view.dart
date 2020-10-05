import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/views/private_web_view.dart';
import 'package:app/ui/widgets/mypage/input_dialog.dart';
import 'package:app/ui/widgets/mypage/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '마이페이지',
                    style: headerStyle,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  myPageListTile(FaIcon(FontAwesomeIcons.tshirt), '사이즈 수정',
                      () => onTapSizeButton(context)),
                  Divider(),
                  myPageListTile(FaIcon(FontAwesomeIcons.search), '최근에 본 상품',
                      () => onTapRecent(context)),
                  Divider(),
                  myPageListTile(FaIcon(FontAwesomeIcons.phoneSquareAlt),
                      '문의﹒건의', () => onTapHelp(context)),
                  Divider(),
                  myPageListTile(FaIcon(FontAwesomeIcons.appStoreIos), '앱 설문조사',
                      () => onTapFeedBack(context)),
                  Divider(),
                  myPageListTile(FaIcon(FontAwesomeIcons.signOutAlt), '로그아웃',
                      () => onTapLogout(context)),
                  Divider(),
                  myPageListTile(FaIcon(FontAwesomeIcons.code), '개인정보 처리방침',
                      () => onTapPrivateInfo(context))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
