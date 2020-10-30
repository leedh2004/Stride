import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/views/recommend/view.dart';
import 'package:app/ui/views/swipe/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'collection/view.dart';
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
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFFAF9FC),
        key: ServiceView.scaffoldKey,
        body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SafeArea(child: SwipeView()),
              SafeArea(child: RecommendView()),
              SafeArea(child: CollectionView()),
              //LookBookView(),
              MyPageView(),
            ]),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 4.0,
                  ),
                ],
                color: Colors.white),
            child: Center(
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.black,
                onTap: (index) {
                  setState(() {});
                },
                // unselectedLabelColor: Colors.white,
                tabs: <Widget>[
                  Container(
                      child: _tabController.index == 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/home_s.png',
                                    width: 24,
                                  ),
                                  Text('홈')
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/home.png',
                                    width: 24,
                                  ),
                                  Text('홈')
                                ])),
                  Container(
                      child: _tabController.index == 1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/heart_s.png',
                                    width: 24,
                                  ),
                                  Text('추천')
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/heart.png',
                                    width: 24,
                                  ),
                                  Text('추천')
                                ])),
                  Container(
                      child: _tabController.index == 2
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/collection_s.png',
                                    width: 24,
                                  ),
                                  Text('드레스룸')
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/collection.png',
                                    width: 24,
                                  ),
                                  Text('드레스룸')
                                ])),
                  Container(
                      child: _tabController.index == 3
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/user_s.png',
                                    width: 24,
                                  ),
                                  Text('MY')
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Image.asset(
                                    'assets/user.png',
                                    width: 24,
                                  ),
                                  Text('MY')
                                ])),
                ],
              ),
            ),
          ),
        ),
        // appBar: PreferredSize(
        //     child:
        //     preferredSize: Size.fromHeight(60))
      ),
    );
  }
}
