import 'dart:async';
import 'dart:convert';
import 'package:app/core/constants/app_constants.dart';
import 'package:app/core/models/swipeCard.dart';
import 'api.dart';

class SwipeService {
  // BehaviorSubject<List<List<SwipeCard>>> _itemsController = BehaviorSubject();
  // Stream<List<List<SwipeCard>>> get items => _itemsController.stream;
  Api _api;
  List<int> index;
  List<int> length;
  int type;
  List<List<SwipeCard>> items;

  SwipeService(Api api) {
    print("SwipeService 생성!");
    // _itemsController.add([[], [], [], [], []]); // All, Top, Skirt, Pants, Dress
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
    items = [[], [], [], [], []];
    if (length[0] == 0) {
      var response = await _api.client.get('${Api.endpoint}/home/all');
      if (response.statusCode == 200) {
        var data = json.decode(response.data) as Map<String, dynamic>;
        List<SwipeCard> all = new List<SwipeCard>();
        List<SwipeCard> top = new List<SwipeCard>();
        List<SwipeCard> dress = new List<SwipeCard>();
        List<SwipeCard> skirt = new List<SwipeCard>();
        List<SwipeCard> pants = new List<SwipeCard>();
        var parsedAll = data['all'] as List<dynamic>;
        var parsedTop = data['top'] as List<dynamic>;
        var parsedDress = data['dress'] as List<dynamic>;
        var parsedSkirt = data['skirt'] as List<dynamic>;
        var parsedPants = data['pants'] as List<dynamic>;
        for (var item in parsedAll) {
          all.add(SwipeCard.fromJson(item));
        }
        for (var item in parsedTop) {
          top.add(SwipeCard.fromJson(item));
        }
        for (var item in parsedDress) {
          dress.add(SwipeCard.fromJson(item));
        }
        for (var item in parsedSkirt) {
          skirt.add(SwipeCard.fromJson(item));
        }
        for (var item in parsedPants) {
          pants.add(SwipeCard.fromJson(item));
        }
        items = [all, top, skirt, pants, dress];
        length = [10, 10, 10, 10, 10];
      } else {
        print(response.statusCode);
      }
    }
  }

  Future<List<SwipeCard>> getAllSwipeCards() async {
    print("getAllSwipeCards()");
    var temp = List<SwipeCard>();
    // fail시 flag로 토스트 메세지 띄워주기
    // time 302, 응답이 느리다, 잠시 후 다시 시도하는 재시도 버튼을 넣는게 바람직한 UI
    var response = await _api.client.get(
      '${Api.endpoint}/home/',
    );
    if (response.statusCode == 200) {
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }
      length[ALL] += parsed.length;
      items = [
        [...items[ALL], ...temp],
        [...items[TOP]],
        [...items[SKIRT]],
        [...items[PANTS]],
        [...items[DRESS]]
      ];
      print("length[ALL]: ${length[ALL]}");
    } else {
      print("Network Error getAllSwipeCard() ${response.statusCode}");
    }
    print("getAllSwipeCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getTopSwipeCards() async {
    print("getTopSwipeCards()");
    var temp = List<SwipeCard>();

    var response = await _api.client.get(
      '${Api.endpoint}/home?type=top',
    );
    if (response.statusCode == 200) {
      var parsed = json.decode(response.data) as List<dynamic>;

      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }

      length[TOP] += parsed.length;
      items = [
        [...items[ALL]],
        [...items[TOP], ...temp],
        [...items[SKIRT]],
        [...items[PANTS]],
        [...items[DRESS]]
      ];
      print("length[TOP]: ${length[TOP]}");
    } else {
      print("Network Error getTopSwipeCard() ${response.statusCode}");
    }
    print("getTopSwipeCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getSkirtSwipeCards() async {
    print("getSkirtWipeCards()");
    var temp = List<SwipeCard>();

    var response = await _api.client.get(
      '${Api.endpoint}/home?type=skirt',
    );
    if (response.statusCode == 200) {
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }
      length[SKIRT] += parsed.length;
      items = [
        [...items[ALL]],
        [...items[TOP]],
        [...items[SKIRT], ...temp],
        [...items[PANTS]],
        [...items[DRESS]]
      ];
      print("length[SKIRT]: ${length[SKIRT]}");
    } else {
      print("Network Error getSkirtSwipeCard() ${response.statusCode}");
    }
    print("getSkirtWipeCards() End");
    return temp;
  }

  Future<List<SwipeCard>> getPantsSwipeCards() async {
    print("getPantsSwipeCards()");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home?type=pants',
    );
    if (response.statusCode == 200) {
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }
      length[PANTS] += parsed.length;
      items = [
        [...items[ALL]],
        [...items[TOP]],
        [...items[SKIRT]],
        [...items[PANTS], ...temp],
        [...items[DRESS]]
      ];
      print("length[PANTS]: ${length[PANTS]}");
    } else {
      print("Network Error getPantsSwipeCard() ${response.statusCode}");
    }
    print("getPantsSwipeCard() End");
    return temp;
  }

  Future<List<SwipeCard>> getDressSwipeCards() async {
    print("getDressSwipeCards()");
    var temp = List<SwipeCard>();
    var response = await _api.client.get(
      '${Api.endpoint}/home?type=dress',
    );
    if (response.statusCode == 200) {
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }
      length[DRESS] += parsed.length;
      items = [
        [...items[ALL]],
        [...items[TOP]],
        [...items[SKIRT]],
        [...items[PANTS]],
        [...items[DRESS], ...temp]
      ];
      print("length[DRESS]: ${length[DRESS]}");
    } else {
      print("Network Error getDressSwipeCard() ${response.statusCode}");
    }
    print("getDressSwipeCard() End");
    return temp;
  }
}
