import 'package:app/core/services/error.dart';
import 'package:dio/dio.dart';

class Api {
  static const endpoint = 'https://api-stride.com';
  var client = new Dio();
  ErrorService _errorService;
  Api(this._errorService);
  void errorCreate(Error e) {
    _errorService.errorCreate(e);
  }
}
