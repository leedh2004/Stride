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
  Map<String, int> index;
  Map<String, int> length;
  Map<String, List<SwipeCard>> items;
  Set<int> precached = new Set();
  bool init = false;

  SwipeService(Api api) {
    print("SwipeService 생성!");
    initialize();
    _api = api;
  }

  bool initialize() {
    index = new Map();
    length = new Map();
    items = new Map();
    for (var type in TYPE) {
      index[type] = 0;
      length[type] = 0;
      items[type] = [];
    }
    type = 'all';
  }

  void changeType(String _type) {
    type = _type;
    print(type);
  }

  void nextItem() {
    precached.remove(items[type][index[type]].product_id);
    index[type]++;
    if (index[type] + 5 >= length[type]) {
      if (index[type] + 2 >= length[type]) {
        index[type]--;
        _api.errorCreate(Error());
      }
      items[type] = items[type].sublist(index[type]);
      index[type] = 0;
      length[type] = items[type].length;
      try {
        getCards();
      } catch (e) {
        index[type]--;
      }
    }
  }

  Future initCards() async {
    initialize();
    try {
      var response = await _api.client.get('${Api.endpoint}/home/all');
      var data = json.decode(response.data) as Map<String, dynamic>;
      print(data);
      for (var type in TYPE) {
        List<SwipeCard> temp = new List<SwipeCard>();
        var parsed = data[type] as List<dynamic>;
        for (var item in parsed) {
          temp.add(SwipeCard.fromJson(item));
        }
        //FOR DEBUG
        for (var item in temp) {
          print(item.product_name);
        }
        //
        items[type] = temp;
        length[type] += temp.length;
      }
      init = true;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  // fail시 flag로 토스트 메세지 띄워주기
  // time 302, 응답이 느리다, 잠시 후 다시 시도하는 재시도 버튼을 넣는게 바람직한 UI
  Future<List<SwipeCard>> getCards() async {
    var temp = List<SwipeCard>();
    var response;
    try {
      if (type == 'all') {
        response = await _api.client.get(
          '${Api.endpoint}/home/',
        );
      } else {
        response = await _api.client.get(
          '${Api.endpoint}/home?type=${type}',
        );
      }

      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(SwipeCard.fromJson(item));
      }
      print("getCards ${index[type]}");
      //FOR DEBUG
      print("SUBLIST");
      // List<SwipeCard> test = items[type].sublist(index[type]);
      // for (var item in test) {
      //   print(item.product_name);
      // }
      items[type] = [...items[type], ...temp];
      length[type] = items[type].length;
      return temp;
    } catch (e) {
      _api.errorCreate(Error());
      throw ("some arbitrary error");
    }
  }

  Future<Product> likeRequest() async {
    print("LIKE!!");
    int cur = index[type];
    try {
      final response = await _api.client.post('${Api.endpoint}/home/like',
          data: jsonEncode({'product_id': items[type][cur].product_id}));
      print("Like ${response.statusCode}");
      Product item = Product.fromSwipeCard(items[type][cur].toJson());
      return item;
    } catch (e) {
      //_api.errorCreate(Error());
    }
  }

  Future dislikeRequest() async {
    print("DISLIKE!!");
    int cur = index[type];
    try {
      final response = await _api.client.post('${Api.endpoint}/home/dislike',
          data: jsonEncode({'product_id': items[type][cur].product_id}));
    } catch (e) {
      //_api.errorCreate(Error());
    }
  }

  Future passRequest() async {
    print("PASS!!");
    int cur = index[type];
    try {
      final response = await _api.client.post('${Api.endpoint}/home/pass',
          data: jsonEncode({'product_id': items[type][cur].product_id}));
    } catch (e) {
      //_api.errorCreate(Error());
    }
  }

  Future purchaseItem(int id) async {
    try {
      await _api.client.post('${Api.endpoint}/home/purchase',
          data: jsonEncode({'product_id': id}));
    } catch (e) {
      // _api.errorCreate(Error());
    }
  }
}
