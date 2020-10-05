import 'package:app/core/models/user.dart';
import 'package:app/ui/views/error_view.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import './tutorial/view.dart';

import 'login_view.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget showWidget;

    return Consumer<Error>(builder: (context, error, child) {
      print(error);
      if (error == null) {
        return Consumer<StrideUser>(builder: (context, user, child) {
          if (user == null) {
            print("!!!");
            showWidget = LoginView();
          } else {
            Stride.analytics.setUserId(user.id);
            if (user.profile_flag) {
              // showWidget = TutorialView();

              showWidget = ServiceView();
            } else {
              showWidget = TutorialView();
            }
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: showWidget);
        });
      } else {
        return ErrorPage();
      }
    });
  }
}
