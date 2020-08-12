import 'dart:convert';

import 'package:app/core/models/product.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/base_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SwipeModel extends BaseModel {
  Api _api;
  DressRoomService _dressRoomService;
  SwipeModel(Api api, DressRoomService dressRoomService) {
    _api = api;
    _dressRoomService = dressRoomService;
  }
  List<Product> items;
  int curIdx = 0;

  Future fetchItems() async {
    setBusy(true);
    items = await _api.getCards();
    setBusy(false);
  }

  void nextItem() {
    setBusy(true);
    curIdx++;
    setBusy(false);
  }

  Future likeRequest() async {
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await _api.client.post('${Api.endpoint}/home/like',
        // headers: {
        //   "Content-Type": "application/json",
        //   "Accept": "application/json",
        //   'Authorization': "Bearer ${token}",
        // },
        data: jsonEncode({'product_id': items[curIdx].product_id}));
    print(response.statusCode);
    // _dressRoomService.items.add(items[curIdx]);
    print(items[curIdx].product_name);
    print("!!!");
    await _dressRoomService.addItem(items[curIdx]);
    print("???");
    nextItem();
  }

  void dislikeRequest() async {
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await _api.client.post('${Api.endpoint}/home/dislike',
        // headers: {
        //   "Content-Type": "application/json",
        //   "Accept": "application/json",
        //   'Authorization': "Bearer ${token}",
        // },
        data: jsonEncode({'product_id': items[curIdx].product_id}));
    print(response.statusCode);
    nextItem();
  }

  void passRequest() async {
    FlutterSecureStorage _storage = new FlutterSecureStorage();
    String token = await _storage.read(key: 'jwt_token');
    final response = await _api.client.post('${Api.endpoint}/home/pass',
        // headers: {
        //   "Content-Type": "application/json",
        //   "Accept": "application/json",
        //   'Authorization': "Bearer ${token}",
        // },
        data: jsonEncode({'product_id': items[curIdx].product_id}));
    print(response.statusCode);
    nextItem();
  }
}
