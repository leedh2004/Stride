import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/base_model.dart';

class SwipeModel extends BaseModel {
  Api _api;
  DressRoomService _dressRoomService;
  SwipeService _swipeService;
  List<List<SwipeCard>> items;
  List<int> index;
  List<int> length;

  int type;

  SwipeModel(Api api, DressRoomService dressRoomService,
      SwipeService swipeService, List<List<SwipeCard>> serviceItems) {
    _api = api;
    _dressRoomService = dressRoomService;
    _swipeService = swipeService;
    type = swipeService.type;
    index = swipeService.index;
    length = swipeService.length;
    items = serviceItems;
    print("SwipeModel 생성!");
    //print(items[1][0].product_name);
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
    print("nextItem()");
    index[type]++;
    print("index: ${index[type]} length: ${length[type]}");

    if (index[type] + 5 >= length[type]) {
      if (type == 0) {
        List<SwipeCard> temp = await _swipeService.getAllSwipeCards();
        items = [
          [...items[0], ...temp],
          [...items[1]],
          [...items[2]],
          [...items[3]],
          [...items[4]]
        ];
      } else if (type == 1) {
        List<SwipeCard> temp = await _swipeService.getTopSwipeCards();
        items = [
          [...items[0]],
          [...items[1], ...temp],
          [...items[2]],
          [...items[3]],
          [...items[4]]
        ];
      } else if (type == 2) {
        List<SwipeCard> temp = await _swipeService.getSkirtSwipeCards();
        items = [
          [...items[0]],
          [...items[1]],
          [...items[2], ...temp],
          [...items[3]],
          [...items[4]]
        ];
      } else if (type == 3) {
        List<SwipeCard> temp = await _swipeService.getPantsSwipeCards();
        items = [
          [...items[0]],
          [...items[1]],
          [...items[2]],
          [...items[3], ...temp],
          [...items[4]]
        ];
      } else if (type == 4) {
        List<SwipeCard> temp = await _swipeService.getDressSwipeCards();
        items = [
          [...items[0]],
          [...items[1]],
          [...items[2]],
          [...items[3]],
          [...items[4], ...temp]
        ];
      }
    }
    setBusy(false);
  }

  Future likeRequest() async {
    print("LIKE!!");
    int cur = index[type];
    final response = await _api.client.post('${Api.endpoint}/home/like',
        data: jsonEncode({'product_id': items[type][cur].product_id}));
    print("Like ${response.statusCode}");
    Product item = Product.fromJson(items[type][cur].toJson());
    print(item.product_name);
    await _dressRoomService.addItem(item);
  }

  void dislikeRequest() async {
    print("DISLIKE!!");
    int cur = index[type];
    final response = await _api.client.post('${Api.endpoint}/home/dislike',
        data: jsonEncode({'product_id': items[type][cur].product_id}));
    print("Dislike ${response.statusCode}");
  }

  void passRequest() async {
    print("PASS!!");
    int cur = index[type];
    final response = await _api.client.post('${Api.endpoint}/home/pass',
        data: jsonEncode({'product_id': items[type][cur].product_id}));
    print("Pass ${response.statusCode}");
  }
}
