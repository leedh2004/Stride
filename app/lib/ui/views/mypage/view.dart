import 'package:app/core/services/authentication_service.dart';
import 'package:app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
          onPressed: () {
            Provider.of<AuthenticationService>(context, listen: false).logout();
          },
          color: backgroundColor,
          child: Text(
            '로그 아웃',
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}
