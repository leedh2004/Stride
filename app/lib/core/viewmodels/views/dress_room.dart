import 'dart:convert';

import 'package:app/core/models/product.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DressRoomModel extends BaseModel {
  //Api _api;
  //DressRoomService dressRoomService;
  List<Product> items;
  DressRoomModel(List<Product> serviceitems) {
    print("드레스룸모델생성~~~~~~~~");
    items = serviceitems;
  }
  //List<Product> items;
  bool isAnyOneSelected = false;

  // Future fetchItems() async {
  //   setBusy(true);
  //   items = await _api.getDressRoom();
  //   setBusy(false);
  // }

  void selectItem(int index) {
    print("clicked");
    items[index].selected = 1 - items[index].selected;
    isAnyOneSelected = false;
    for (var item in items) {
      if (item.selected == 1) {
        isAnyOneSelected = true;
        break;
      }
    }
    notifyListeners();
  }

  List<Product> findSelectedTop() {
    List<Product> top = List<Product>();
    for (int i = 0; i < items.length; i++) {
      if (items[i].selected == 1 && items[i].type == 'top') {
        print(items[i].product_name);
        print(items[i].type);
        top.add(items[i]);
      }
    }
    print("상의길이");
    print(top.length);
    return top;
  }

  List<Product> findSelectedBotoom() {
    List<Product> bottom = List<Product>();
    for (int i = 0; i < items.length; i++) {
      if (items[i].selected == 1 &&
          (items[i].type == 'skirt' || items[i].type == 'pants')) {
        print(items[i].type);
        print(items[i].product_name);
        bottom.add(items[i]);
      }
    }
    print("하의길이");
    print(bottom.length);

    return bottom;
  }

  void removeItem() async {
    List<int> removedIds = List<int>();
    for (var element in items) {
      print("내가 궁금한값");
      print(element.selected);
      print(element.product_id);
      if (element.selected == 1) {
        removedIds.add(element.product_id);
        //print("삭제할것 : ${element.product_id}");
      }
    }
    items.removeWhere((element) => element.selected == 1);
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await http.post('${Api.endpoint}/dressroom/delete/',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode({'product_id': removedIds}));
    print(response.statusCode);
    notifyListeners();
  }

  void makeCoordinate(int top, int bottom) async {
    print(top);
    print(bottom);
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await http.post('${Api.endpoint}/coordination/',
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': "Bearer ${token}",
        },
        body: jsonEncode({'top_product_id': top, 'bottom_product_id': bottom}));
    print(response.statusCode);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
