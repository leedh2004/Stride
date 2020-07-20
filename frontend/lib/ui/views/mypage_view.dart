import 'package:flutter/material.dart';
import 'package:frontend/core/models/user.dart';
import 'package:frontend/core/services/authentication_service.dart';
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
            color: Colors.blue,
            child: Text('로그 아웃')));
  }
}
