import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class SwipeModel extends BaseModel {
  Api _api;
  DressRoomService _dressRoomService;
  SwipeService _swipeService;
  List<List<SwipeCard>> items;
  int curIdx;
  int type;

  SwipeModel(Api api, DressRoomService dressRoomService,
      SwipeService swipeService, List<List<SwipeCard>> serviceItems) {
    _api = api;
    _dressRoomService = dressRoomService;
    _swipeService = swipeService;
    type = swipeService.type;
    curIdx = swipeService.index[type];
    items = serviceItems;
    print("SwipeModel 생성!");
  }
  void changeType(String str) {
    if (str == 'all') {
      _swipeService.changeType(0);
      type = _swipeService.type;
    } else if (str == 'top') {
      _swipeService.changeType(1);
      type = _swipeService.type;
      print(type);
    } else if (str == 'skirt') {
      _swipeService.changeType(2);
      type = _swipeService.type;
    } else if (str == 'pants') {
      _swipeService.changeType(3);
      type = _swipeService.type;
    } else if (str == 'dress') {
      _swipeService.changeType(4);
      type = _swipeService.type;
    }
    notifyListeners();
  }

  void nextItem() async {
    setBusy(true);
    curIdx++;
    _swipeService.index[type]++;
    if (_swipeService.index[type] + 5 == _swipeService.length) {
      if (type == 0) {
        List<SwipeCard> temp = await _swipeService.getAllSwipeCards();
        //items = [...items, ...temp];
      }
    }
    setBusy(false);
  }

  Future likeRequest() async {
    print("LIKE please!!");
    // final response = await _api.client.post('${Api.endpoint}/home/like',
    //     data: jsonEncode({'product_id': items[curIdx].product_id}));
    // print("Like ${response.statusCode}");
    // Product item = Product.fromJson(items[curIdx].toJson());
    // print(item.product_name);
    // await _dressRoomService.addItem(item);
    //nextItem();
  }

  void dislikeRequest() async {
    // final response = await _api.client.post('${Api.endpoint}/home/dislike',
    //     data: jsonEncode({'product_id': items[curIdx].product_id}));
    // print("Dislike ${response.statusCode}");
    //nextItem();
  }

  void passRequest() async {
    // final response = await _api.client.post('${Api.endpoint}/home/pass',
    //     data: jsonEncode({'product_id': items[curIdx].product_id}));
    // print("Pass ${response.statusCode}");
    //nextItem();
  }
}
