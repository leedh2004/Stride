import 'package:apple_sign_in/apple_sign_in.dart';

class ConfigService {
  final String currentVersion = "0.9.6";
  ConfigService(this.isAppleAvailable, this.updateVersion);
  final bool isAppleAvailable;
  final String updateVersion;
  static Future<bool> check() async {
    return await AppleSignIn.isAvailable();
  }

  bool alreadyShow = false;
}
