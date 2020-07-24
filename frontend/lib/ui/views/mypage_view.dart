import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/services/authentication_service.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/text_styles.dart';
import 'package:provider/provider.dart';

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FlatButton(
            onPressed: () {
              print('로그 아웃 버튼 Clicked');
              Provider.of<AuthenticationService>(context, listen: false)
                  .logout();
            },
            color: backgroundColor,
            child: Text(
              '로그 아웃',
              style: TextStyle(color: Colors.white),
            )));
  }
}
