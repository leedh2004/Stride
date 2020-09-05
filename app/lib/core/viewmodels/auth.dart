import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/viewmodels/base_model.dart';

class AuthenticationModel extends BaseModel {
  AuthenticationService authService;
  AuthenticationModel(this.authService);
  Future init() async {
    await authService.checkToken();
    notifyListeners();
  }
}
