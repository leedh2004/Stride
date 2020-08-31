import 'package:app/core/models/user.dart';
import 'package:app/ui/views/service_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'login_view.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget showWidget;
    return Consumer<StrideUser>(builder: (context, user, child) {
      if (user == null) {
        showWidget = LoginView();
      } else {
        Stride.analytics.setUserId(user.id);
        showWidget = ServiceView();
      }
      return AnimatedSwitcher(
          duration: Duration(milliseconds: 500), child: showWidget);
    });
  }
}
