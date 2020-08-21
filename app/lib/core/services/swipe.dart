import 'dart:async';
import 'dart:convert';
import 'package:app/core/constants/app_constants.dart';
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
    type = ALL;
  }

  void changeType(int _type) {
    type = _type;
    print(type);
  }

  Future initCards() async {
    await Future.wait([
      getTopSwipeCards(),
      getDressSwipeCards(),
      getPantsSwipeCards(),
      getSkirtSwipeCards(),
      getAllSwipeCards()
    ]);
  }

  Future<List<SwipeCard>> getAllSwipeCards() async {
    print("getAllSwipeCards()");
    var temp = List<SwipeCard>();

    int statusCode = -1;
    var parsed;
    // fail시 flag로 토스트 메세지 띄워주기
    // time 302, 응답이 느리다, 잠시 후 다시 시도하는 재시도 버튼을 넣는게 바람직한 UI
    while (statusCode != 200) {
      var response = await _api.client.get(
        '${Api.endpoint}/home/',
      );
      statusCode = response.statusCode;
      parsed = json.decode(response.data) as List<dynamic>;
    }

    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }

    length[ALL] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[ALL], ...temp],
      [..._itemsController.value[TOP]],
      [..._itemsController.value[SKIRT]],
      [..._itemsController.value[PANTS]],
      [..._itemsController.value[DRESS]]
    ]);

    print("getAllCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getTopSwipeCards() async {
    print("getTopSwipeCards()");
    var temp = List<SwipeCard>();

    int statusCode = -1;
    var parsed;

    while (statusCode != 200) {
      var response = await _api.client.get(
        '${Api.endpoint}/home?type=top',
      );
      statusCode = response.statusCode;
      parsed = json.decode(response.data) as List<dynamic>;
    }

    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }

    length[TOP] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[ALL]],
      [..._itemsController.value[TOP], ...temp],
      [..._itemsController.value[SKIRT]],
      [..._itemsController.value[PANTS]],
      [..._itemsController.value[DRESS]]
    ]);
    print("getTopCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getSkirtSwipeCards() async {
    print("getSkirtWipeCards()");
    var temp = List<SwipeCard>();

    int statusCode = -1;
    var parsed;
    while (statusCode != 200) {
      var response = await _api.client.get(
        '${Api.endpoint}/home?type=skirt',
      );
      statusCode = response.statusCode;
      parsed = json.decode(response.data) as List<dynamic>;
    }

    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[SKIRT] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[ALL]],
      [..._itemsController.value[TOP]],
      [..._itemsController.value[SKIRT], ...temp],
      [..._itemsController.value[PANTS]],
      [..._itemsController.value[DRESS]]
    ]);
    print("getSkirtWipeCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getPantsSwipeCards() async {
    print("getPantsSwipeCards()");
    var temp = List<SwipeCard>();
    int statusCode = -1;
    var parsed;
    while (statusCode != 200) {
      var response = await _api.client.get(
        '${Api.endpoint}/home?type=pants',
      );
      statusCode = response.statusCode;
      parsed = json.decode(response.data) as List<dynamic>;
    }
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[PANTS] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[ALL]],
      [..._itemsController.value[TOP]],
      [..._itemsController.value[SKIRT]],
      [..._itemsController.value[PANTS], ...temp],
      [..._itemsController.value[DRESS]]
    ]);
    print("getAllPantsSwipeCard() End");
    return temp;
  }

  Future<List<SwipeCard>> getDressSwipeCards() async {
    print("getDressSwipeCards()");
    var temp = List<SwipeCard>();
    int statusCode = -1;
    var parsed;
    while (statusCode != 200) {
      var response = await _api.client.get(
        '${Api.endpoint}/home?type=dress',
      );
      statusCode = response.statusCode;
      parsed = json.decode(response.data) as List<dynamic>;
    }
    for (var item in parsed) {
      temp.add(SwipeCard.fromJson(item));
    }
    length[DRESS] += parsed.length;
    _itemsController.add([
      [..._itemsController.value[ALL]],
      [..._itemsController.value[TOP]],
      [..._itemsController.value[SKIRT]],
      [..._itemsController.value[PANTS]],
      [..._itemsController.value[DRESS], ...temp]
    ]);
    print("getAllDressSwipeCard() End");
    return temp;
  }
}
