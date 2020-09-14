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

  Future login(String accessToken, String channel) async {
    setBusy(true);
    await authService.login(accessToken, channel);
    setBusy(false);
  }

  Future<String> loginWithApple({List<Scope> scopes = const []}) async {
    String email = await authService.loginWithApple(scopes: scopes);
    return login(email, "apple");
  }
}
