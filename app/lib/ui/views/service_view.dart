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
                child: SvgPicture.asset(
                  'images/menu_swipe.svg',
                  width: 36,
                  height: 36,
                  color: _tabController.index == 0
                      ? backgroundColor
                      : Color.fromRGBO(233, 236, 244, 1),
                ),
              )),
              Tab(
                  icon: Container(
                padding: EdgeInsets.all(12),
                child: SvgPicture.asset('images/menu_heart.svg',
                    color: _tabController.index == 1
                        ? backgroundColor
                        : Color.fromRGBO(233, 236, 244, 1)),
              )),
              Tab(
                  icon: Padding(
                padding: EdgeInsets.only(top: 6),
                child: Container(
                  width: 30,
                  height: 30,
                  child: FaIcon(FontAwesomeIcons.thLarge,
                      color: _tabController.index == 2
                          ? backgroundColor
                          : Color.fromRGBO(233, 236, 244, 1)),
                ),
              )),
              Tab(
                icon: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Container(
                    width: 30,
                    height: 30,
                    // padding: EdgeInsets.all(12),
                    child: FaIcon(FontAwesomeIcons.userAlt,
                        color: _tabController.index == 3
                            ? backgroundColor
                            : Color.fromRGBO(233, 236, 244, 1)),
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
