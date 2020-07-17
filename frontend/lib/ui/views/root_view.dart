import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Root View'),
        ],
      )),
    );
  }
}
