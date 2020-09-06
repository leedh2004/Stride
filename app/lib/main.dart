// // Copyright 2017 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:kakao_flutter_sdk/all.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:http/http.dart' as http;
// // import 'tabs_page.dart';

// void main() {
//   KakaoContext.clientId = "caa6c865e94aa692c781ac217de8f393";
//   KakaoContext.javascriptClientId = "89c24b397212dabdb28a3ebcbdcc86af";
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   static FirebaseAnalytics analytics = FirebaseAnalytics();
//   static FirebaseAnalyticsObserver observer =
//       FirebaseAnalyticsObserver(analytics: analytics);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase Analytics Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       navigatorObservers: <NavigatorObserver>[observer],
//       home: MyHomePage(
//         title: 'Firebase Analytics Demo',
//         analytics: analytics,
//         observer: observer,
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title, this.analytics, this.observer})
//       : super(key: key);

//   final String title;
//   final FirebaseAnalytics analytics;
//   final FirebaseAnalyticsObserver observer;

//   @override
//   _MyHomePageState createState() => _MyHomePageState(analytics, observer);
// }

// class _MyHomePageState extends State<MyHomePage> {
//   _MyHomePageState(this.analytics, this.observer);

//   final FirebaseAnalyticsObserver observer;
//   final FirebaseAnalytics analytics;
//   final storage = new FlutterSecureStorage();

//   String _message = '';

//   void setMessage(String message) {
//     setState(() {
//       _message = message;
//     });
//   }

//   Future<void> _sendAnalyticsEvent() async {
//     await analytics.logEvent(
//       name: 'test_event',
//       parameters: <String, dynamic>{
//         'string': 'string',
//         'int': 42,
//         'long': 12345678910,
//         'double': 42.0,
//         'bool': true,
//       },
//     );
//     setMessage('logEvent succeeded');
//   }

//   Future<void> _testSetUserId() async {
//     await analytics.setUserId('some-user');
//     setMessage('setUserId succeeded');
//   }

//   Future<void> _testSetCurrentScreen() async {
//     await analytics.setCurrentScreen(
//       screenName: 'Analytics Demo',
//       screenClassOverride: 'AnalyticsDemo',
//     );
//     setMessage('setCurrentScreen succeeded');
//   }

//   Future<void> _testSetAnalyticsCollectionEnabled() async {
//     await analytics.setAnalyticsCollectionEnabled(false);
//     await analytics.setAnalyticsCollectionEnabled(true);
//     setMessage('setAnalyticsCollectionEnabled succeeded');
//   }

//   Future<void> _testSetSessionTimeoutDuration() async {
//     await analytics.android?.setSessionTimeoutDuration(2000000);
//     setMessage('setSessionTimeoutDuration succeeded');
//   }

//   Future<void> _testSetUserProperty() async {
//     await analytics.setUserProperty(name: 'regular', value: 'indeed');
//     setMessage('setUserProperty succeeded');
//   }

//   Future<void> _testAllEventTypes() async {
//     await analytics.logAddPaymentInfo();
//     await analytics.logAddToCart(
//       currency: 'USD',
//       value: 123.0,
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       quantity: 5,
//       price: 24.0,
//       origin: 'test origin',
//       itemLocationId: 'test location id',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-17',
//     );
//     await analytics.logAddToWishlist(
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       quantity: 5,
//       price: 24.0,
//       value: 123.0,
//       currency: 'USD',
//       itemLocationId: 'test location id',
//     );
//     await analytics.logAppOpen();
//     await analytics.logBeginCheckout(
//       value: 123.0,
//       currency: 'USD',
//       transactionId: 'test tx id',
//       numberOfNights: 2,
//       numberOfRooms: 3,
//       numberOfPassengers: 4,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-17',
//       travelClass: 'test travel class',
//     );
//     await analytics.logCampaignDetails(
//       source: 'test source',
//       medium: 'test medium',
//       campaign: 'test campaign',
//       term: 'test term',
//       content: 'test content',
//       aclid: 'test aclid',
//       cp1: 'test cp1',
//     );
//     await analytics.logEarnVirtualCurrency(
//       virtualCurrencyName: 'bitcoin',
//       value: 345.66,
//     );
//     await analytics.logEcommercePurchase(
//       currency: 'USD',
//       value: 432.45,
//       transactionId: 'test tx id',
//       tax: 3.45,
//       shipping: 5.67,
//       coupon: 'test coupon',
//       location: 'test location',
//       numberOfNights: 3,
//       numberOfRooms: 4,
//       numberOfPassengers: 5,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-13',
//       endDate: '2015-09-14',
//       travelClass: 'test travel class',
//     );
//     await analytics.logGenerateLead(
//       currency: 'USD',
//       value: 123.45,
//     );
//     await analytics.logJoinGroup(
//       groupId: 'test group id',
//     );
//     await analytics.logLevelUp(
//       level: 5,
//       character: 'witch doctor',
//     );
//     await analytics.logLogin();
//     await analytics.logPostScore(
//       score: 1000000,
//       level: 70,
//       character: 'tiefling cleric',
//     );
//     await analytics.logPresentOffer(
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       quantity: 6,
//       price: 3.45,
//       value: 67.8,
//       currency: 'USD',
//       itemLocationId: 'test item location id',
//     );
//     await analytics.logPurchaseRefund(
//       currency: 'USD',
//       value: 45.67,
//       transactionId: 'test tx id',
//     );
//     await analytics.logSearch(
//       searchTerm: 'hotel',
//       numberOfNights: 2,
//       numberOfRooms: 1,
//       numberOfPassengers: 3,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-16',
//       travelClass: 'test travel class',
//     );
//     await analytics.logSelectContent(
//       contentType: 'test content type',
//       itemId: 'test item id',
//     );
//     await analytics.logShare(
//         contentType: 'test content type',
//         itemId: 'test item id',
//         method: 'facebook');
//     await analytics.logSignUp(
//       signUpMethod: 'test sign up method',
//     );
//     await analytics.logSpendVirtualCurrency(
//       itemName: 'test item name',
//       virtualCurrencyName: 'bitcoin',
//       value: 34,
//     );
//     await analytics.logTutorialBegin();
//     await analytics.logTutorialComplete();
//     await analytics.logUnlockAchievement(id: 'all Firebase API covered');
//     await analytics.logViewItem(
//       itemId: 'test item id',
//       itemName: 'test item name',
//       itemCategory: 'test item category',
//       itemLocationId: 'test item location id',
//       price: 3.45,
//       quantity: 6,
//       currency: 'USD',
//       value: 67.8,
//       flightNumber: 'test flight number',
//       numberOfPassengers: 3,
//       numberOfRooms: 1,
//       numberOfNights: 2,
//       origin: 'test origin',
//       destination: 'test destination',
//       startDate: '2015-09-14',
//       endDate: '2015-09-15',
//       searchTerm: 'test search term',
//       travelClass: 'test travel class',
//     );
//     await analytics.logViewItemList(
//       itemCategory: 'test item category',
//     );
//     await analytics.logViewSearchResults(
//       searchTerm: 'test search term',
//     );
//     setMessage('All standard events logged successfully');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         children: <Widget>[
//           MaterialButton(
//             child: const Text('Test logEvent'),
//             onPressed: _sendAnalyticsEvent,
//           ),
//           MaterialButton(
//             child: const Text('Test standard event types'),
//             onPressed: _testAllEventTypes,
//           ),
//           MaterialButton(
//             child: const Text('Test setUserId'),
//             onPressed: _testSetUserId,
//           ),
//           MaterialButton(
//             child: const Text('Test setCurrentScreen'),
//             onPressed: _testSetCurrentScreen,
//           ),
//           MaterialButton(
//             child: const Text('Test setAnalyticsCollectionEnabled'),
//             onPressed: _testSetAnalyticsCollectionEnabled,
//           ),
//           MaterialButton(
//             child: const Text('Test setSessionTimeoutDuration'),
//             onPressed: _testSetSessionTimeoutDuration,
//           ),
//           MaterialButton(
//             child: const Text('Test setUserProperty'),
//             onPressed: _testSetUserProperty,
//           ),
//           Text(_message,
//               style: const TextStyle(color: Color.fromARGB(255, 0, 155, 0))),
//           RaisedButton(
//             onPressed: () async {
// try {
//   String authCode = await AuthCodeClient.instance.request();
//   // AccessToken token = await AuthApi.instance.issueAccessToken(authCode);
//   // AccessTokenStore.instance.toCache(token);
//   print(authCode);
//   print('ZZ');
// } on KakaoAuthException catch (e) {
//   // some error happened during the course of user login... deal with it.
//   print("Error ${e}");
// } on KakaoClientException catch (e) {
//   //
//   print("Error ${e}");
// } catch (e) {
//   //
//   print("Error ${e}");
// }
//               String value = await storage.read(key: 'jwt_token');
//               print(value);
//               if (value == null) {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => KakaoPAge()));
//               } else {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => LoginedPage()));
//               }
//             },
//             child: Text('카카오톡 로그인'),
//             color: Colors.yellow[100],
//           )
//           // Image.network(
//           //     'https://stridedodamshindam.s3.ap-northeast-2.amazonaws.com/BENITO0.jpg')
//         ],
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //     child: const Icon(Icons.tab),
//       //     onPressed: () {
//       //       Navigator.of(context).push(MaterialPageRoute<TabsPage>(
//       //           settings: const RouteSettings(name: TabsPage.routeName),
//       //           builder: (BuildContext context) {
//       //             return TabsPage(observer);
//       //           }));
//       //     }),
//     );
//   }
// }

// class KakaoPAge extends StatelessWidget {
//   @override
//   String redirect_uri = "http://15.165.33.138:5000/auth/oauth";
//   String client_id = "ffc1ec82f333d835621df9caa8511e64";
//   final storage = new FlutterSecureStorage();

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: WebView(
//         javascriptChannels: <JavascriptChannel>[
//           JavascriptChannel(
//               name: 'jwt_token',
//               onMessageReceived: (JavascriptMessage msg) async {
//                 print(msg.message);
//                 await storage.write(key: 'jwt_token', value: msg.message);
//                 Navigator.pop(context);
//               })
//         ].toSet(),
//         initialUrl:
//             'https://kauth.kakao.com/oauth/authorize?client_id=${client_id}&redirect_uri=${redirect_uri}&response_type=code',
//         javascriptMode: JavascriptMode.unrestricted,
//       )),
//     );
//   }
// }

// class LoginedPage extends StatelessWidget {
//   final storage = new FlutterSecureStorage();

//   Future fetchPost() async {
//     String token = await storage.read(key: 'jwt_token');
//     print("Bearer ${token}");
//     Map<String, String> requestHeaders = {'Authorization': '<Your token>'};
//     final response = await http.get(
//       'http://15.165.33.138:5000/login/token',
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//         'Authorization': "Bearer ${token}",
//       },
//     );
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       //만료안하고 성공
//       final responseJson = json.decode(response.body);
//       print(responseJson);
//     } else {
//       //만료해버림
//       //404헤더가 아님, 403은 만료됐다.
//     }
//     //print(responseJson);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Text('로그인완료'),
//               RaisedButton(
//                 child: Text('리퀘스트'),
//                 onPressed: () async {
//                   await fetchPost();
//                 },
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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

import 'core/services/apple_sign_in.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  KakaoContext.clientId = "caa6c865e94aa692c781ac217de8f393";
  KakaoContext.javascriptClientId = "89c24b397212dabdb28a3ebcbdcc86af";
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

  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  final currentVersion = "0.1.0";
  final updatedVersion = remoteConfig.getString('version');
  // await remoteConfig.fetch(expiration: const Duration(seconds: 0));
  // await remoteConfig.activateFetched();
  // print("VERSION");
  // runZoned(() {
  //   runApp(Stride());
  // }, onError: Crashlytics.instance.recordError);
  // runApp(Stride());
  runApp(Provider<ConfigService>.value(
      value: ConfigService(appleSignInAvailable, updatedVersion),
      child: Stride()));
}

class Stride extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen(); // 앱 시작.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
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
