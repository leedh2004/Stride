import 'dart:convert';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/base_model.dart';

class SwipeModel extends BaseModel {
  DressRoomService _dressRoomService;
  SwipeService _swipeService;
  List<int> index;
  List<int> length;
  bool trick = false;
  int type;

  SwipeModel(DressRoomService dressRoomService, SwipeService swipeService) {
    _dressRoomService = dressRoomService;
    _swipeService = swipeService;
    type = swipeService.type;
    index = swipeService.index;
    length = swipeService.length;
    print("SwipeModel 생성!");
    //print(items[1][0].product_name);
  }

  Future initCards() async {
    await _swipeService.initCards();
    notifyListeners();
  }

  void changeType(String str) {
    if (str == 'all') {
      _swipeService.changeType(ALL);
      type = _swipeService.type;
    } else if (str == 'top') {
      _swipeService.changeType(TOP);
      type = _swipeService.type;
      print(type);
    } else if (str == 'skirt') {
      _swipeService.changeType(SKIRT);
      type = _swipeService.type;
    } else if (str == 'pants') {
      _swipeService.changeType(PANTS);
      type = _swipeService.type;
    } else if (str == 'dress') {
      _swipeService.changeType(DRESS);
      type = _swipeService.type;
    }
    notifyListeners();
  }

  void test() async {
    print("TEST");
    setBusy(true);
    trick = true;
    await Future.delayed(Duration(milliseconds: 500));
    nextItem();
    print('?');
    trick = false;
    setBusy(false);
    notifyListeners();
  }

  void nextItem() async {
    setBusy(true);
    print("nextItem()");
    index[type]++;
    print("index: ${index[type]} length: ${length[type]}");

    if (index[type] + 5 >= length[type]) {
      if (type == ALL) {
        await _swipeService.getAllSwipeCards();
      } else if (type == TOP) {
        await _swipeService.getTopSwipeCards();
      } else if (type == SKIRT) {
        await _swipeService.getSkirtSwipeCards();
      } else if (type == PANTS) {
        await _swipeService.getPantsSwipeCards();
      } else if (type == DRESS) {
        await _swipeService.getDressSwipeCards();
      }
    }
    setBusy(false);
  }

  Future likeRequest() async {
    print("LIKE!!");
    // int cur = index[type];
    // final response = await _api.client.post('${Api.endpoint}/home/like',
    //     data: jsonEncode({'product_id': items[type][cur].product_id}));
    // print("Like ${response.statusCode}");
    // Product item = Product.fromSwipeCard(items[type][cur].toJson());
    // print(item.product_name);
    // await _dressRoomService.addItem(item);
  }

  void dislikeRequest() async {
    // print("DISLIKE!!");
    // int cur = index[type];
    // final response = await _api.client.post('${Api.endpoint}/home/dislike',
    //     data: jsonEncode({'product_id': items[type][cur].product_id}));
    // print("Dislike ${response.statusCode}");
  }

  void passRequest() async {
    // print("PASS!!");
    // int cur = index[type];
    // final response = await _api.client.post('${Api.endpoint}/home/pass',
    //     data: jsonEncode({'product_id': items[type][cur].product_id}));
    // print("Pass ${response.statusCode}");
  }
}
