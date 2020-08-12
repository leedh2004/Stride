import 'dart:convert';
import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  static const endpoint = 'https://www.api-stride.com';
  var client = new Dio();
}
