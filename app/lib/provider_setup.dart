import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/recommend.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/error.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/swipe.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/models/user.dart';
import 'core/services/api.dart';
import 'core/services/recent_item.dart';
import 'core/services/tutorial.dart';

// 모든 Provider의 집합
List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

// 독립적인 Provider
List<SingleChildWidget> independentServices = [
  //Provider.value(value: Api()),
  Provider.value(value: ErrorService()),
];

// 다른 Provider의 값에 의존하는 Provider
List<SingleChildWidget> dependentServices = [
  ProxyProvider<ErrorService, Api>(
    update: (context, errorService, api) => Api(errorService),
  ),
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticatonService) => AuthenticationService(api),
  ),
  ProxyProvider<Api, DressRoomService>(
    update: (context, api, _) => DressRoomService(api),
  ),
  ProxyProvider<Api, LookBookService>(
    update: (context, api, _) => LookBookService(api),
  ),
  ProxyProvider<Api, SwipeService>(
    update: (context, api, _) => SwipeService(api),
  ),
  ProxyProvider<Api, TutorialService>(
    update: (context, api, _) => TutorialService(api),
  ),
  ProxyProvider<Api, RecentItemService>(
    update: (context, api, _) => RecentItemService(api),
  ),
  ProxyProvider<Api, RecommendationService>(
    update: (context, api, _) => RecommendationService(api),
  ),
];

// Provider 값의 변화를 관찰하는 UI Observer
List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<StrideUser>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  ),
  StreamProvider<Error>(
    create: (context) =>
        Provider.of<ErrorService>(context, listen: false).error,
  ),
];
