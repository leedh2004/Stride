import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/swipeCard.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class SwipeService {
  BehaviorSubject<List<List<SwipeCard>>> _itemsController = BehaviorSubject();
  Stream<List<List<SwipeCard>>> get items => _itemsController.stream;
  Api _api;
  List<int> index;
  List<int> length;
  int type;

  SwipeService(Api api) {
    print("SwipeService 생성!");
    _api = api;
    index = [0, 0, 0, 0, 0];
    length = [0, 0, 0, 0, 0];
    type = 0;
    _itemsController.add([[], [], [], [], []]); // All, Top, Skirt, Pants, Dress
    getTopSwipeCards();
    getAllSwipeCards();
  }

  void changeType(int _type) {
    type = _type;
    print("wwwtttfff");
    print(type);
  }

  Future<List<SwipeCard>> getAllSwipeCards() async {
    print("getCard() Start");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home/',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[0] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[0], ...temp],
      [..._itemsController.value[1]],
      [..._itemsController.value[2]],
      [..._itemsController.value[3]],
      [..._itemsController.value[4]]
    ]);
  }

  Future<List<SwipeCard>> getTopSwipeCards() async {
    print("getCard() Start");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home?type=top',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    print(temp[0].product_name);
    length[1] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[0]],
      [..._itemsController.value[1], ...temp],
      [..._itemsController.value[2]],
      [..._itemsController.value[3]],
      [..._itemsController.value[4]]
    ]);
    print("getCard() End");
    return temp;
  }
}
