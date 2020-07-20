import 'package:frontend/core/services/authentication_service.dart';
import 'package:frontend/core/viewmodels/views/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/models/user.dart';
// import 'package:provider_arc/core/services/api.dart';
// import 'package:provider_arc/core/services/authentication_service.dart';
// import 'core/models/user.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  //Provider.value(value: LoginViewModel()),
  Provider.value(value: AuthenticationService())
];

List<SingleChildWidget> dependentServices = [
  // ProxyProvider<Api, AuthenticationService>(
  //   update: (context, api, authenticationService) =>
  //       AuthenticationService(api: api),
  // )
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<User>(
    create: (context) =>
        Provider.of<AuthenticationService>(context, listen: false).user,
  )
];
