import 'package:flutter/material.dart';
// import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider_setup.dart';
import 'package:frontend/ui/router.dart';

import 'core/constants/app_constants.dart';

void main() {
  // KakaoContext.clientId = "caa6c865e94aa692c781ac217de8f393";
  // KakaoContext.javascriptClientId = "89c24b397212dabdb28a3ebcbdcc86af";

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: RoutePaths.Login,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
