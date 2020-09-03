import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'images/profile.png',
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '반가워요!',
                      style: subHeaderStyle,
                    ),
                    Text(
                      '황희담 님',
                      style: headerStyle,
                    )
                  ],
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
                child: Material(
                  color: Colors.transparent,
                  child: ListView(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 50),
                        leading: FaIcon(FontAwesomeIcons.tshirt),
                        title: Text('사이즈 수정'),
                        onTap: () => print("HI"),
                      ),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 50),
                        leading: FaIcon(FontAwesomeIcons.phoneSquareAlt),
                        title: Text('고객센터'),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 50),
                        leading: FaIcon(FontAwesomeIcons.appStoreIos),
                        title: Text('앱 리뷰쓰기'),
                        onTap: () {},
                      ),
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 50),
                        leading: FaIcon(FontAwesomeIcons.signOutAlt),
                        title: Text('로그아웃'),
                        onTap: () {
                          Provider.of<SwipeService>(context, listen: false)
                              .init = false;
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
                        title: Text('튜토리얼'),
                        onTap: () {
                          print('?');
                          Navigator.pushNamed(context, RoutePaths.Tutorial);
                        },
                      ),
                    ],
                  ),
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
