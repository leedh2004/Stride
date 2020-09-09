import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/swipe/view.dart';
import 'package:app/ui/widgets/radius_container.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dressroom/view.dart';
import 'lookbook/view.dart';
import 'mypage/view.dart';

class ServiceView extends StatefulWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  const ServiceView({Key key}) : super(key: key);
  @override
  _ServiceViewState createState() => new _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: ServiceView.scaffoldKey,
        body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SwipeView(),
              DressRoomView(),
              LookBookView(),
              MyPageView(),
            ]),
        appBar: PreferredSize(
            child: AppBar(
              elevation: 0,
              backgroundColor: backgroundColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.black,
                onTap: (index) {
                  setState(() {});
                },
                // unselectedLabelColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                      icon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      'images/menu_swipe.svg',
                      width: 36,
                      height: 36,
                      color: _tabController.index == 0
                          ? Colors.black
                          : Colors.white,
                    ),
                  )),
                  Tab(
                      icon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset('images/menu_heart.svg',
                        color: _tabController.index == 1
                            ? Colors.black
                            : Colors.white),
                  )),
                  Tab(
                      icon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset('images/menu_lookbook.svg',
                        width: 36,
                        height: 36,
                        color: _tabController.index == 2
                            ? Colors.black
                            : Colors.white),
                  )),
                  Tab(
                      icon: Container(
                    padding: EdgeInsets.all(12),
                    child: SvgPicture.asset('images/menu_mypage.svg',
                        width: 36,
                        height: 36,
                        color: _tabController.index == 3
                            ? Colors.black
                            : Colors.white),
                  )),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60)));
  }
}
