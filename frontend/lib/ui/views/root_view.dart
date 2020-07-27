import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/ui/views/login_view.dart';
import 'package:frontend/ui/views/tab_bar_controller_view.dart';
import 'package:provider/provider.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      Widget showWidget;
      if (user == null) {
        showWidget = LoginView();
      } else {
        showWidget = TabBarControllerView();
      }
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: showWidget,
      );
    });
  }
}
