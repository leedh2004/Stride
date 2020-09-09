import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/models/user.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/widgets/mypage/input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// 중간발표때까지 탭하면 가는거 구현, 튜토리얼, 이미지메이커, UI 바꾸기, Crashlytics, Analytics

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(242, 243, 247, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              color: Color.fromRGBO(242, 243, 247, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: ListView(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 50),
                      leading: FaIcon(FontAwesomeIcons.tshirt),
                      title: Text('사이즈 수정'),
                      onTap: () {
                        print("!!!");
                        showMaterialModalBottomSheet(
                          isDismissible: true,
                          expand: false,
                          context: context,
                          builder: (_context, controller) => SizeInputDialog(
                              Provider.of<AuthenticationService>(_context,
                                      listen: false)
                                  .userController
                                  .value),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 50),
                      leading: FaIcon(FontAwesomeIcons.phoneSquareAlt),
                      title: Text('문의﹒건의'),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 50),
                      leading: FaIcon(FontAwesomeIcons.appStoreIos),
                      title: Text('앱 피드백'),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 50),
                      leading: FaIcon(FontAwesomeIcons.signOutAlt),
                      title: Text('로그아웃'),
                      onTap: () {
                        Provider.of<SwipeService>(context, listen: false).init =
                            false;
                        Provider.of<DressRoomService>(context, listen: false)
                            .init = false;
                        Provider.of<LookBookService>(context, listen: false)
                            .init = false;
                        Provider.of<AuthenticationService>(context,
                                listen: false)
                            .logout();
                      },
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 50),
                      leading: FaIcon(FontAwesomeIcons.code),
                      title: Text('개인정보 처리방침'),
                      onTap: () {
                        print('?');
                        Navigator.pushNamed(context, RoutePaths.Tutorial);
                      },
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 50),
                      leading: FaIcon(FontAwesomeIcons.code),
                      title: Text('서비스 이용약관'),
                      onTap: () {
                        print('?');
                        Navigator.pushNamed(context, RoutePaths.Tutorial);
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
// <a href='https://pngtree.com/so/플랫-아바타'>플랫-아바타 png from pngtree.com</a>
// return Center(
//   child: FlatButton(
//       onPressed: () {
//         Provider.of<AuthenticationService>(context, listen: false).logout();
//       },
//       color: backgroundColor,
//       child: Text(
//         '로그 아웃',
//         style: TextStyle(color: Colors.white),
//       )),
// );
