import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/swipeCard.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class SwipeService {
  BehaviorSubject<List<SwipeCard>> _itemsController = BehaviorSubject();
  Stream<List<SwipeCard>> get items => _itemsController.stream;
  Api _api;
  int curIdx;
  int length;

  SwipeService(Api api) {
    print("SwipeService 생성!");
    _api = api;
    curIdx = 0;
    length = 0;
    _itemsController.add([]);
    getSwipeCards();
  }

  Future<List<SwipeCard>> getSwipeCards() async {
    print("getCard() Start");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home/',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length += parsed.length;
    _itemsController.add([..._itemsController.value, ...temp]);
    print("getCard() End");
    return temp;
  }
}
