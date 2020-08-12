import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'core/models/product.dart';
import 'core/models/user.dart';
import 'core/services/api.dart';

// List<SingleChildCloneableWidget> providers = [
//   ...independentServices,
//   ...dependentServices,
//   ...uiConsumableProviders
// ];

// List<SingleChildCloneableWidget> dependentServices = [
//   ProxyProvider<Api, AuthenticationService>(
//     update: (context, api, authenticatonService) => AuthenticationService(api),
//   ),
//   ProxyProvider<Api, DressRoomService>(
//     update: (context, api, dressRoomService) => DressRoomService(api),
//   )
// ];

// List<SingleChildCloneableWidget> independentServices = [
//   Provider.value(value: Api()),
// ];

// List<SingleChildCloneableWidget> uiConsumableProviders = [
//   StreamProvider<User>(
//     create: (context) =>
//         Provider.of<AuthenticationService>(context, listen: false).user,
//   ),
//   StreamProvider<List<Product>>(
//     create: (context) =>
//         Provider.of<DressRoomService>(context, listen: false).items,
//   )
// ];

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthenticationService>(
    update: (context, api, authenticatonService) => AuthenticationService(api),
  ),
  ProxyProvider<Api, DressRoomService>(
    update: (context, api, dressRoomService) => DressRoomService(api),
  )
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api()),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  ),
  StreamProvider<List<Product>>(
    create: (context) =>
        Provider.of<DressRoomService>(context, listen: false).items,
  )
];
