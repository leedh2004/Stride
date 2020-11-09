import 'dart:async';
import 'dart:io';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/services/config.dart';
import 'package:app/provider_setup.dart';
import 'package:app/ui/router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:provider/provider.dart';

bool emulator = false;
// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
final _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
final _kTestingCrashlytics = false;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 9;
  }
}

Future<void> main() async {
  print("START");
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  HttpOverrides.global = MyHttpOverrides();
  final appleSignInAvailable = await ConfigService.check();
  KakaoContext.clientId = "caa6c865e94aa692c781ac217de8f393";
  await Firebase.initializeApp();

  // Crashlytics.instance.enableInDevMode = true;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
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
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  await remoteConfig.activateFetched();
  final updatedVersion = remoteConfig.getString('version').trim();
  print(updatedVersion);
  runZonedGuarded(() {
    runApp(Provider<ConfigService>.value(
        value: ConfigService(appleSignInAvailable, updatedVersion),
        child: Stride()));
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  // runApp(Stride());
}

class Stride extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAuth auth = FirebaseAuth.instance;
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);
  static logEvent({String name}) {
    if (!emulator) {
      analytics.logEvent(name: name);
    } else {
      print("@@@@@@@@@@@ EVENT : " + name + "@@@@@@@@@@@@@@@@");
    }
  }

  @override
  _StrideState createState() => _StrideState();
}

class _StrideState extends State<Stride> {
  Future<void> _initializeFlutterFireFuture;

  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();
    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }

  @override
  void initState() {
    super.initState();
    _initializeFlutterFireFuture = _initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    // analytics.logAppOpen(); // 앱 시작.
    //가로 방향 회전 금지
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: providers,
      child: FutureBuilder(
          future: _initializeFlutterFireFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'stride',
                  theme: ThemeData(
                    fontFamily: 'Nanum',
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    //for modal..
                    // highlightColor: Colors.transparent,
                    // splashColor: Colors.transparent
                  ),
                  initialRoute: RoutePaths.Root,
                  onGenerateRoute: Router.generateRoute,
                  // navigatorObservers: [widget.observer],
                );
              default:
                return Container();
            }
          }),
    );
  }
}
