import 'package:app/core/models/user.dart';
import 'package:app/ui/shared/flush.dart';
import 'package:app/ui/views/error_view.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:app/ui/widgets/swipe/no_swipe_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_view.dart';

class RootView extends StatefulWidget {
  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  DateTime currentBackPressTime;

  Future<bool> onWillPop() async {
    currentBackPressTime = DateTime.now();
    Future<bool> ret;
    await exit.show(context).then((value) {
      DateTime now = DateTime.now();
      print(now);
      print(currentBackPressTime);
      if (now.difference(currentBackPressTime) > Duration(milliseconds: 1900)) {
        ret = Future.value(false);
      } else {
        ret = Future.value(true);
      }
    });
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Consumer<Error>(builder: (context, error, child) {
        if (error == null) {
          return Consumer<StrideUser>(builder: (context, user, child) {
            if (user == null) {
              showWidget = LoginView();
            } else {
              showWidget = ServiceView();
            }
            return AnimatedSwitcher(
                duration: Duration(milliseconds: 500), child: showWidget);
          });
        } else {
          return ErrorPage();
        }
      }),
    );
  }
}
