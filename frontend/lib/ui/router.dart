import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/ui/views/login_view.dart';
import 'package:frontend/ui/views/root_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (_) => RootView());
      case RoutePaths.Login:
        return MaterialPageRoute(builder: (_) => LoginView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
