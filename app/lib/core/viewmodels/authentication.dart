import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/base_model.dart';
import 'package:apple_sign_in/scope.dart';

class AuthenticationModel extends BaseModel {
  AuthenticationService authService;
  AuthenticationModel(this.authService);

  Future init() async {
    await authService.checkToken();
    notifyListeners();
  }

  Future login(String accessToken, String channel, String name) async {
    setBusy(true);
    await authService.login(accessToken, channel, name);
    setBusy(false);
  }

  Future<String> loginWithApple({List<Scope> scopes = const []}) async {
    List<String> ret = await authService.loginWithApple(scopes: scopes);
    print(ret[1]);
    if (ret[1] == 'nullnull') {
      ret[1] = null;
      print("!!@@");
    }
    return login(ret[0], "apple", ret[1]);
  }
}
