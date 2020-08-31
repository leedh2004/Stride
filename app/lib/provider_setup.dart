import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/models/user.dart';
import 'core/services/api.dart';

// 모든 Provider의 집합
List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

// 독립적인 Provider
List<SingleChildWidget> independentServices = [
  Provider.value(value: Api()),
];

// 다른 Provider의 값에 의존하는 Provider
List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticatonService) => AuthenticationService(api),
  ),
  ProxyProvider<Api, DressRoomService>(
    update: (context, api, dressRoomService) => DressRoomService(api),
  ),
  ProxyProvider<Api, LookBookService>(
    update: (context, api, dressRoomService) => LookBookService(api),
  ),
  ProxyProvider<Api, SwipeService>(
    update: (context, api, dressRoomService) => SwipeService(api),
  ),
];

// Provider 값의 변화를 관찰하는 UI Observer
List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<StrideUser>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  ),
  // StreamProvider<List<Product>>(
  //   create: (context) =>
  //       Provider.of<DressRoomService>(context, listen: false).items,
  // ),
  // StreamProvider<List<List<SwipeCard>>>(
  //   create: (context) =>
  //       Provider.of<SwipeService>(context, listen: false).items,
  // ),
  // StreamProvider<List<Coordinate>>(
  //   create: (context) =>
  //       Provider.of<LookBookService>(context, listen: false).items,
  // )
];
