import 'dart:convert';
import 'dart:io';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  static const endpoint = 'https://www.api-stride.com';
  var client = new Dio();

  Future<List<Product>> getCards() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt_token');
    var items = List<Product>();
    var response = await client.get(
      '$endpoint/home',
      // headers: {
      //"Content-Type": "application/json",
      //"Accept": "application/json",
      // HttpHeaders.authorizationHeader: 'Bearer ${token}',
      //HttpHeaders.refererHeader: 'http://api-stride.com:5000/'
      // },
    );
    //실패시 처리
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      items.add(Product.fromJson(item));
    }
    //print(items[0]);
    return items;
  }

  Future<List<Product>> getDressRoom() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt_token');

    var items = List<Product>();
    var response = await client.get(
      '$endpoint/dressroom/',
      // headers: {
      //   "Content-Type": "application/json",
      //   "Accept": "application/json",
      //   'Authorization': "Bearer ${token}",
      // },
    );
    //실패시 처리
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      items.add(Product.fromJson(item));
    }
    //print(items[0]);
    return items;
  }

  Future<List<Coordinate>> getCoordinate() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt_token');

    var items = List<Coordinate>();
    var response = await client.get(
      '$endpoint/coordination/',
      // headers: {
      //   "Content-Type": "application/json",
      //   "Accept": "application/json",
      //   'Authorization': "Bearer ${token}",
      // },
    );
    print(response.statusCode);
    print(response);
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      print(item);
      items.add(Coordinate.fromJson(item));
    }
    print('end');
    return items;
  }
}
