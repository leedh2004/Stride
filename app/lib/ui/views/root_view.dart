import 'package:app/core/models/user.dart';
import 'package:app/core/services/error.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:app/ui/shared/text_styles.dart';
import 'package:app/ui/shared/ui_helper.dart';
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
              showWidget = ServiceView();
            } else {
              showWidget = TutorialView();
            }
          }
          return AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: showWidget);
        });
      } else {
        return Scaffold(
            body: Container(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/fix.png',
                  width: 100,
                  height: 100,
                ),
                UIHelper.verticalSpaceSmall,
                Text("일시적인 오류입니다", style: headerStyle),
                UIHelper.verticalSpaceSmall,
                Text("네트워크 상태를 점검해주세요.", style: dressRoomsubHeaderStyle),
                UIHelper.verticalSpaceSmall,
                Text("새로고침을 눌러 앱을 재실행할 수 있습니다.",
                    style: dressRoomsubHeaderStyle),
                UIHelper.verticalSpaceMedium,
                RaisedButton(
                  color: backgroundColor,
                  onPressed: () {
                    Provider.of<ErrorService>(context, listen: false)
                        .errorCreate(null);
                  },
                  child: Text(
                    '새로고침',
                    style: whiteStyle,
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                Text('오류가 지속된다면, '),
                Text('help.stride@gmail.com 으로 문의 주세요.')
              ],
            ),
          ),
        ));
      }
    });
  }
}
