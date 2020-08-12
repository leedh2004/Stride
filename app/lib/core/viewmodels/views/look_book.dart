import 'dart:convert';

import 'package:app/core/models/coordinate.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LookBookModel extends BaseModel {
  Api _api;
  LookBookModel({@required Api api}) : _api = api;
  List<Coordinate> items;

  Future fetchItems() async {
    setBusy(true);
    items = await _api.getCoordinate();
    setBusy(false);
  }

  void removeItem(int id) async {
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await http.post('${Api.endpoint}/coordination/delete',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode({'coor_id': id}));
    if (response.statusCode == 200) {
      items.removeWhere((element) => element.id == id);
    }
    print(response.statusCode);
    notifyListeners();
  }

  void rename(int index, String name) async {
    print("$name rename");
    items[index].name = name;
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await http.put('${Api.endpoint}/coordination/',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode({'coor_id': items[index].id, 'update_name': name}));
    print(response.statusCode);

    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
