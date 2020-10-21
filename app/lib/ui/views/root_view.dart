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
    // var configService = Provider.of<ConfigService>(context, listen: false);
    // if ((configService.currentVersion[0] != configService.updateVersion[0])) {
    //   return Scaffold(
    //     body: Container(
    //       child: Stack(
    //         children: [
    //           Container(
    //             width: double.infinity,
    //             child: Image.asset(
    //               'images/intro.png',
    //               fit: BoxFit.cover,
    //             ),
    //           ),
    //           Align(
    //             alignment: Alignment.center + Alignment(0, 0.5),
    //             child: Container(
    //               padding: EdgeInsets.all(16),
    //               child: Text(
    //                 '죄송합니다.\n현재 버전의 앱을 더 이상 지원하지 않습니다.\n원할한 사용을 위해 업데이트 해주시면 감사하겠습니다.',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontSize: 18, color: Colors.white),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    return Consumer<Error>(builder: (context, error, child) {
      print(error);
      if (error == null) {
        return Consumer<StrideUser>(builder: (context, user, child) {
          if (user == null) {
            // print("!!!");
            showWidget = LoginView();
          } else {
            // Stride.analytics.setUserId(user.id);
            // if (user.profile_flag) {
            // showWidget = TutorialView();
            showWidget = ServiceView();
            // } else {
            // showWidget = TutorialView();
            // }
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
