import 'package:app/core/constants/app_constants.dart';
import 'package:app/ui/views/root_view.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Root:
        return MaterialPageRoute(builder: (_) => RootView());
    }
  }
}
