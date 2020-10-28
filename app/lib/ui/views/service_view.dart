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
        key: ServiceView.scaffoldKey,
        body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SafeArea(child: SwipeView()),
              SafeArea(child: RecommendView()),
              SafeArea(child: CollectionView()),
              //LookBookView(),
              SafeArea(child: MyPageView()),
            ]),
        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          color: Colors.white,
          child: TabBar(
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
                child: _tabController.index == 0
                    ? Image.asset('assets/home_s.png')
                    : Image.asset('assets/home.png'),
              )),
              Tab(
                  icon: Container(
                padding: EdgeInsets.all(12),
                child: _tabController.index == 1
                    ? Image.asset('assets/heart_s.png')
                    : Image.asset('assets/heart.png'),
              )),
              Tab(
                  icon: Padding(
                padding: EdgeInsets.only(top: 6),
                child: Container(
                  width: 30,
                  height: 30,
                  child: _tabController.index == 2
                      ? Image.asset('assets/collection_s.png')
                      : Image.asset('assets/collection.png'),
                ),
              )),
              Tab(
                icon: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Container(
                    width: 30,
                    height: 30,
                    // padding: EdgeInsets.all(12),
                    child: _tabController.index == 3
                        ? Image.asset('assets/user_s.png')
                        : Image.asset('assets/user.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        // appBar: PreferredSize(
        //     child:
        //     preferredSize: Size.fromHeight(60))
      ),
    );
  }
}
