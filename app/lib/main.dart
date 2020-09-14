import 'dart:async';
import 'dart:io';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/services/config.dart';
import 'package:app/provider_setup.dart';
import 'package:app/ui/router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  final appleSignInAvailable = await ConfigService.check();
  final FirebaseMessaging fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
    );
  }
  KakaoContext.clientId = "caa6c865e94aa692c781ac217de8f393";
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  await remoteConfig.activateFetched();
  final updatedVersion = remoteConfig.getString('version').trim();
  runZoned(() {
    runApp(Provider<ConfigService>.value(
        value: ConfigService(appleSignInAvailable, updatedVersion),
        child: Stride()));
  }, onError: Crashlytics.instance.recordError);
  // runApp(Stride());
}

class Stride extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen(); // 앱 시작.
    //가로 방향 회전 금지
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'stride',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            //for modal..
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent),
        initialRoute: RoutePaths.Root,
        onGenerateRoute: Router.generateRoute,
        navigatorObservers: [observer],
      ),
    );
  }
}
