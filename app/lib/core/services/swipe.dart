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

  Future nextItem() async {
    if (index[type] + 5 >= length[type]) {
      await getCards();
    }
    index[type]++;
  }

  Future initCards() async {
    initialize();
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

  Future dislikeRequest() async {
    print("DISLIKE!!");
    int cur = index[type];
    final response = await _api.client.post('${Api.endpoint}/home/dislike',
        data: jsonEncode({'product_id': items[type][cur].product_id}));
    print("Dislike ${response.statusCode}");
  }

  Future passRequest() async {
    print("PASS!!");
    int cur = index[type];
    final response = await _api.client.post('${Api.endpoint}/home/pass',
        data: jsonEncode({'product_id': items[type][cur].product_id}));
    print("Pass ${response.statusCode}");
  }

  Future purchaseItem(int id) async {
    await _api.client.post('${Api.endpoint}/home/purchase',
        data: jsonEncode({'product_id': id}));
  }
}
