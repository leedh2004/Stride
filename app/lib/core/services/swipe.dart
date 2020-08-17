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
    _itemsController.add([[], [], [], [], []]); // All, Top, Skirt, Pants, Dress
    _api = api;
    index = [0, 0, 0, 0, 0];
    length = [0, 0, 0, 0, 0];
    type = 0;
    initCards();
  }

  void changeType(int _type) {
    type = _type;
    print(type);
  }

  Future initCards() async {
    await getTopSwipeCards();
    await getDressSwipeCards();
    await getPantsSwipeCards();
    await getSkirtSwipeCards();
    await getAllSwipeCards();
  }

  Future<List<SwipeCard>> getAllSwipeCards() async {
    print("getAllSwipeCards()");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home/',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[0] += parsed.length;
    print("service length[0]: ${length[0]}");
    _itemsController.add([
      [..._itemsController.value[0], ...temp],
      [..._itemsController.value[1]],
      [..._itemsController.value[2]],
      [..._itemsController.value[3]],
      [..._itemsController.value[4]]
    ]);
    print("getAllCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getTopSwipeCards() async {
    print("getTopSwipeCards()");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home?type=top',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[1] += parsed.length;
    print(length[1]);
    _itemsController.add([
      [..._itemsController.value[0]],
      [..._itemsController.value[1], ...temp],
      [..._itemsController.value[2]],
      [..._itemsController.value[3]],
      [..._itemsController.value[4]]
    ]);
    print("getTopCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getSkirtSwipeCards() async {
    print("getSkirtWipeCards()");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home?type=skirt',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[2] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[0]],
      [..._itemsController.value[1]],
      [..._itemsController.value[2], ...temp],
      [..._itemsController.value[3]],
      [..._itemsController.value[4]]
    ]);
    print("getSkirtWipeCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getPantsSwipeCards() async {
    print("getPantsSwipeCards()");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home?type=pants',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[3] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[0]],
      [..._itemsController.value[1]],
      [..._itemsController.value[2]],
      [..._itemsController.value[3], ...temp],
      [..._itemsController.value[4]]
    ]);
    print("getAllPantsSwipeCard() End");
    return temp;
  }

  Future<List<SwipeCard>> getDressSwipeCards() async {
    print("getDressSwipeCards()");
    var temp = List<SwipeCard>();
    print("service length[1]: ${length[1]}");
    print("service length[0]: ${length[0]}");

    var response = await _api.client.get(
      '${Api.endpoint}/home?type=dress',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[4] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[0]],
      [..._itemsController.value[1]],
      [..._itemsController.value[2]],
      [..._itemsController.value[3]],
      [..._itemsController.value[4], ...temp]
    ]);
    print("getAllDressSwipeCard() End");
    return temp;
  }
}
