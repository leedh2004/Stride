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
  List<SwipeCard> items;
  int curIdx;

  SwipeModel(Api api, DressRoomService dressRoomService,
      SwipeService swipeService, List<SwipeCard> serviceItems) {
    _api = api;
    _dressRoomService = dressRoomService;
    _swipeService = swipeService;
    items = serviceItems;
    curIdx = swipeService.curIdx;
    print("SwipeModel 생성!");
  }

  void nextItem() async {
    setBusy(true);
    curIdx++;
    _swipeService.curIdx++;
    if (curIdx + 5 == _swipeService.length) {
      List<SwipeCard> temp = await _swipeService.getSwipeCards();
      items = [...items, ...temp];
      print(items.length);
    }
    setBusy(false);
  }

  Future likeRequest() async {
    print("LIKE please!!");
    final response = await _api.client.post('${Api.endpoint}/home/like',
        data: jsonEncode({'product_id': items[curIdx].product_id}));
    print("Like ${response.statusCode}");
    Product item = Product.fromJson(items[curIdx].toJson());
    print(item.product_name);
    await _dressRoomService.addItem(item);
    //nextItem();
  }

  void dislikeRequest() async {
    final response = await _api.client.post('${Api.endpoint}/home/dislike',
        data: jsonEncode({'product_id': items[curIdx].product_id}));
    print("Dislike ${response.statusCode}");
    //nextItem();
  }

  void passRequest() async {
    final response = await _api.client.post('${Api.endpoint}/home/pass',
        data: jsonEncode({'product_id': items[curIdx].product_id}));
    print("Pass ${response.statusCode}");
    //nextItem();
  }
}
