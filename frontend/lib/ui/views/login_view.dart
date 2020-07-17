import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Login View'),
          FlatButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, RoutePaths.Home);
              },
              color: Colors.blue,
              child: Text('Go to Home'))
        ],
      )),
    );
  }
}
