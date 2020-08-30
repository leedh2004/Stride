import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/swipeCard.dart';
import 'api.dart';

const List<String> TYPE = ['all', 'top', 'skirt', 'pants', 'dress'];

class SwipeService {
  // BehaviorSubject<List<List<SwipeCard>>> _itemsController = BehaviorSubject();
  // Stream<List<List<SwipeCard>>> get items => _itemsController.stream;
  Api _api;
  String type;
  Map<String, int> index = new Map();
  Map<String, int> length = new Map();
  Map<String, List<SwipeCard>> items = new Map();
  bool init = false;

  SwipeService(Api api) {
    print("SwipeService 생성!");
    _api = api;
    for (var type in TYPE) {
      index[type] = 0;
      length[type] = 0;
      items[type] = [];
    }
    type = 'all';
    print(type);
  }

  void changeType(String _type) {
    type = _type;
    print(type);
  }

  Future nextItem() async {
    if (index[type] + 5 >= length[type]) {
      await getCards();
    }
    index[type]++;
  }

  Future initCards() async {
    print('init');
    var response = await _api.client.get('${Api.endpoint}/home/all');
    if (response.statusCode == 200) {
      var data = json.decode(response.data) as Map<String, dynamic>;
      print(data);

      for (var type in TYPE) {
        List<SwipeCard> temp = new List<SwipeCard>();
        var parsed = data[type] as List<dynamic>;
        for (var item in parsed) {
          temp.add(SwipeCard.fromJson(item));
        }
        items[type] = temp;
        length[type] += temp.length;
      }
      print("HERE");
      print(type);
      init = true;
    } else {
      print(response.statusCode);
    }
  }

  Future<List<SwipeCard>> getCards() async {
    var temp = List<SwipeCard>();
    // fail시 flag로 토스트 메세지 띄워주기
    // time 302, 응답이 느리다, 잠시 후 다시 시도하는 재시도 버튼을 넣는게 바람직한 UI
    var response;
    if (type == 'all') {
      response = await _api.client.get(
        '${Api.endpoint}/home/',
      );
    } else {
      response = await _api.client.get(
        '${Api.endpoint}/home?type=${type}',
      );
    }
    if (response.statusCode == 200) {
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }
      items[type] = [...items[type], ...temp];
      length[type] += parsed.length;
    } else {
      print("Network Error getAllSwipeCard() ${response.statusCode}");
    }
    return temp;
  }

  Future<Product> likeRequest() async {
    print("LIKE!!");
    int cur = index[type];
    print(type);
    print(cur);
    final response = await _api.client.post('${Api.endpoint}/home/like',
        data: jsonEncode({'product_id': items[type][cur].product_id}));
    print("Like ${response.statusCode}");
    Product item = Product.fromSwipeCard(items[type][cur].toJson());
    return item;
    //print(item.product_name);
    //await _dressRoomService.addItem(item);
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

  // Future<List<SwipeCard>> getAllSwipeCards() async {
  //   print("getAllSwipeCards()");
  //   var temp = List<SwipeCard>();
  //   // fail시 flag로 토스트 메세지 띄워주기
  //   // time 302, 응답이 느리다, 잠시 후 다시 시도하는 재시도 버튼을 넣는게 바람직한 UI
  //   var response = await _api.client.get(
  //     '${Api.endpoint}/home/',
  //   );
  //   if (response.statusCode == 200) {
  //     var parsed = json.decode(response.data) as List<dynamic>;
  //     for (var item in parsed) {
  //       temp.add(SwipeCard.fromJson(item));
  //     }
  //     length[ALL] += parsed.length;
  //     items = [
  //       [...items[ALL], ...temp],
  //       [...items[TOP]],
  //       [...items[SKIRT]],
  //       [...items[PANTS]],
  //       [...items[DRESS]]
  //     ];
  //     print("length[ALL]: ${length[ALL]}");
  //   } else {
  //     print("Network Error getAllSwipeCard() ${response.statusCode}");
  //   }
  //   print("getAllSwipeCards() End");
  //   return temp;
  // }

  // Future<List<SwipeCard>> getTopSwipeCards() async {
  //   print("getTopSwipeCards()");
  //   var temp = List<SwipeCard>();

  //   var response = await _api.client.get(
  //     '${Api.endpoint}/home?type=top',
  //   );
  //   if (response.statusCode == 200) {
  //     var parsed = json.decode(response.data) as List<dynamic>;

  //     for (var item in parsed) {
  //       temp.add(SwipeCard.fromJson(item));
  //     }

  //     length[TOP] += parsed.length;
  //     items = [
  //       [...items[ALL]],
  //       [...items[TOP], ...temp],
  //       [...items[SKIRT]],
  //       [...items[PANTS]],
  //       [...items[DRESS]]
  //     ];
  //     print("length[TOP]: ${length[TOP]}");
  //   } else {
  //     print("Network Error getTopSwipeCard() ${response.statusCode}");
  //   }
  //   print("getTopSwipeCards() End");
  //   return temp;
  // }

  // Future<List<SwipeCard>> getSkirtSwipeCards() async {
  //   print("getSkirtWipeCards()");
  //   var temp = List<SwipeCard>();

  //   var response = await _api.client.get(
  //     '${Api.endpoint}/home?type=skirt',
  //   );
  //   if (response.statusCode == 200) {
  //     var parsed = json.decode(response.data) as List<dynamic>;
  //     for (var item in parsed) {
  //       temp.add(SwipeCard.fromJson(item));
  //     }
  //     length[SKIRT] += parsed.length;
  //     items = [
  //       [...items[ALL]],
  //       [...items[TOP]],
  //       [...items[SKIRT], ...temp],
  //       [...items[PANTS]],
  //       [...items[DRESS]]
  //     ];
  //     print("length[SKIRT]: ${length[SKIRT]}");
  //   } else {
  //     print("Network Error getSkirtSwipeCard() ${response.statusCode}");
  //   }
  //   print("getSkirtWipeCards() End");
  //   return temp;
  // }

  // Future<List<SwipeCard>> getPantsSwipeCards() async {
  //   print("getPantsSwipeCards()");
  //   var temp = List<SwipeCard>();
  //   var response = await _api.client.get(
  //     '${Api.endpoint}/home?type=pants',
  //   );
  //   if (response.statusCode == 200) {
  //     var parsed = json.decode(response.data) as List<dynamic>;
  //     for (var item in parsed) {
  //       temp.add(SwipeCard.fromJson(item));
  //     }
  //     length[PANTS] += parsed.length;
  //     items = [
  //       [...items[ALL]],
  //       [...items[TOP]],
  //       [...items[SKIRT]],
  //       [...items[PANTS], ...temp],
  //       [...items[DRESS]]
  //     ];
  //     print("length[PANTS]: ${length[PANTS]}");
  //   } else {
  //     print("Network Error getPantsSwipeCard() ${response.statusCode}");
  //   }
  //   print("getPantsSwipeCard() End");
  //   return temp;
  // }

  // Future<List<SwipeCard>> getDressSwipeCards() async {
  //   print("getDressSwipeCards()");
  //   var temp = List<SwipeCard>();
  //   var response = await _api.client.get(
  //     '${Api.endpoint}/home?type=dress',
  //   );
  //   if (response.statusCode == 200) {
  //     var parsed = json.decode(response.data) as List<dynamic>;
  //     for (var item in parsed) {
  //       temp.add(SwipeCard.fromJson(item));
  //     }
  //     length[DRESS] += parsed.length;
  //     items = [
  //       [...items[ALL]],
  //       [...items[TOP]],
  //       [...items[SKIRT]],
  //       [...items[PANTS]],
  //       [...items[DRESS], ...temp]
  //     ];
  //     print("length[DRESS]: ${length[DRESS]}");
  //   } else {
  //     print("Network Error getDressSwipeCard() ${response.statusCode}");
  //   }
  //   print("getDressSwipeCard() End");
  //   return temp;
  // }
}
