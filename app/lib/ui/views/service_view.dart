import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/swipe/view.dart';
import 'package:app/ui/widgets/radius_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dressroom/view.dart';
import 'lookbook/view.dart';
import 'mypage/view.dart';

class ServiceView extends StatelessWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: backgroundColor,
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            RadiusContainer(MyPageView()),
            RadiusContainer(SwipeView()),
            RadiusContainer(DressRoomView()),
            RadiusContainer(LookBookView())
          ]),
          appBar: PreferredSize(
              child: AppBar(
                elevation: 0,
                backgroundColor: backgroundColor,
                bottom: TabBar(
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.white, width: 3.0),
                      insets: EdgeInsets.fromLTRB(20, 0, 20, 5)),
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Tab(icon: FaIcon(FontAwesomeIcons.userAlt)),
                    Tab(icon: FaIcon(FontAwesomeIcons.fire)),
                    Tab(icon: FaIcon(FontAwesomeIcons.solidHeart)),
                    Tab(icon: FaIcon(FontAwesomeIcons.thLarge)),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(60))),
    );
  }
}
