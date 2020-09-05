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
      initialIndex: 0,
      child: Scaffold(
          key: scaffoldKey,
          body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
            RadiusContainer(SwipeView()),
            DressRoomView(),
            LookBookView(),
            MyPageView(),
          ]),
          appBar: PreferredSize(
              child: AppBar(
                elevation: 0,
                backgroundColor: backgroundColor,
                bottom: TabBar(
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.white,
                  tabs: <Widget>[
                    Tab(icon: FaIcon(FontAwesomeIcons.fire)),
                    Tab(icon: FaIcon(FontAwesomeIcons.solidHeart)),
                    Tab(icon: FaIcon(FontAwesomeIcons.thLarge)),
                    Tab(icon: FaIcon(FontAwesomeIcons.userAlt)),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(60))),
    );
  }
}
