import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/views/dress_room_view.dart';
import 'package:frontend/ui/views/look_book_view.dart';
import 'package:frontend/ui/views/swipe_view.dart';
import 'package:frontend/ui/widgets/radius_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mypage_view.dart';

class TabBarControllerView extends StatelessWidget {
  final FirebaseUser user;

  const TabBarControllerView({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: backgroundColor,
            bottom: TabBar(
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                    insets: EdgeInsets.fromLTRB(20, 0, 20, 5)),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(icon: FaIcon(FontAwesomeIcons.userAlt)),
                  Tab(icon: FaIcon(FontAwesomeIcons.fire)),
                  Tab(icon: FaIcon(FontAwesomeIcons.thLarge)),
                  Tab(icon: FaIcon(FontAwesomeIcons.shoppingBag)),
                ]),
          ),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          RadiusContainer(MyPageView()),
          RadiusContainer(SwipeView()),
          RadiusContainer(DressRoomView()),
          RadiusContainer(LookBookView())
        ]),
      ),
    );
  }
}
