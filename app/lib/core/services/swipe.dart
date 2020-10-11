import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'api.dart';

const List<String> TYPE = ['all', 'top', 'skirt', 'pants', 'dress'];

class Filter {
  Set<String> types = new Set();
  Set<String> concepts = new Set();
  Set<String> colors = new Set();
  int start_price = 1;
  int end_price = 60000;
  bool size_toggle = true;

  Filter() {
    types.add('all');
    concepts.add('all');
    colors.add('all');
  }

  Filter.from(Filter _filter) {
    types = Set.from(_filter.types);
    concepts = Set.from(_filter.concepts);
    colors = Set.from(_filter.colors);
    start_price = _filter.start_price;
    end_price = _filter.end_price;
    size_toggle = _filter.size_toggle;
  }

  void setTypes(List<String> type) {
    types.clear();
    types.addAll(type);
  }

  void setConcepts(List<String> type) {
    concepts.clear();
    concepts.addAll(type);
  }

  void setColors(List<String> color) {
    colors.clear();
    colors.addAll(color);
  }

  void setPrice(int start, int end) {
    start_price = start;
    end_price = end;
  }

  void setSize(bool value) {
    size_toggle = value;
  }

  bool isNotchangedFilter(int index) {
    switch (index) {
      case 0:
        return types.contains('all');
        break;
      case 1:
        return concepts.contains('all');
        break;
      case 2:
        return start_price == 1 && end_price == 60000;
        break;
      case 3:
        return colors.contains('all');
        break;
      case 4:
        return !size_toggle;
        break;
    }
  }

  bool allNotchangedFilter() {
    return concepts.contains('all') &&
        types.contains('all') &&
        start_price == 1 &&
        end_price == 60000 &&
        colors.contains('all') &&
        size_toggle;
  }

  String getFilterQuery() {
    String sizeflag = this.size_toggle ? 'on' : 'off';
    String types = this
        .types
        .toList()
        .toString()
        .replaceFirst('[', '')
        .replaceFirst(']', '')
        .replaceAll(' ', '');
    String colors = this
        .colors
        .toList()
        .toString()
        .replaceFirst('[', '')
        .replaceFirst(']', '')
        .replaceAll(' ', '');

    String concepts = this
        .concepts
        .toList()
        .toString()
        .replaceFirst('[', '')
        .replaceFirst(']', '')
        .replaceAll(' ', '');

    print(types);
    print(colors);
    return 'price=${start_price},${end_price}&size=${sizeflag}&type=${types}&color=${colors}&concept=${concepts}';
  }
}

class SwipeService {
  int index = 0;
  int length = 0;
  List<RecentItem> items;
  Api _api;
  Set<int> precached = new Set();
  bool init = false;
  Filter filter = new Filter();

  SwipeService(Api api) {
    print("SwipeService 생성!");
    // initialize();
    _api = api;
  }

  bool isNotchangedFilter(int index) {
    return filter.isNotchangedFilter(index);
  }

  void setFilter(Filter _filter) async {
    filter = Filter.from(_filter);
    await initCards();
  }

  void changeSizeFlag(bool value) {
    filter.setSize(value);
  }

  void changeType(List<String> type) {
    filter.setTypes(type);
  }

  void nextItem() {
    print("nextItem()");
    print("LENGTH: ${length}, INDEX: ${index}");
    precached.remove(items[index].product_id);
    index++;
    if (index + 5 >= length) {
      if (index + 2 >= length) {
        index--;
        _api.errorCreate(Error());
      }
      items = items.sublist(index);
      index = 0;
      length = items.length;
      try {
        getCards();
      } catch (e) {
        index--;
      }
    }
  }

  Future initCards() async {
    // initialize();
    var temp = List<RecentItem>();
    try {
      print("INIT CARDS!");
      String query = filter.getFilterQuery();
      var response =
          await _api.client.get('${Api.endpoint}/v2/home?$query&exception=');
      print("END INIT CARDS");
      print(response.data);
      var data = json.decode(response.data) as List<dynamic>;
      for (var item in data) {
        temp.add(RecentItem.fromJson(item));
      }
      for (var item in temp) {
        print(item.product_name);
      }
      items = temp;
      length = temp.length;
      init = true;
    } catch (e) {
      print(e);
      print("???");
      _api.errorCreate(Error());
    }
  }

  // fail시 flag로 토스트 메세지 띄워주기
  // time 302, 응답이 느리다, 잠시 후 다시 시도하는 재시도 버튼을 넣는게 바람직한 UI
  Future<List<RecentItem>> getCards() async {
    print("getCards()!!!!!!!!!!!!");
    var temp = List<RecentItem>();
    try {
      String query = filter.getFilterQuery();
      var response =
          await _api.client.get('${Api.endpoint}/v2/home?$query&exception=');
      var data = json.decode(response.data) as List<dynamic>;
      for (var item in data) {
        temp.add(RecentItem.fromJson(item));
      }
      items = [...items, ...temp];
      length = items.length;
      return temp;
    } catch (e) {
      _api.errorCreate(Error());
      throw ("some arbitrary error");
    }
  }

  Future<Product> likeRequest() async {
    print("LIKE!!");
    try {
      final response = await _api.client.post('${Api.endpoint}/home/like',
          data: jsonEncode({'product_id': items[index].product_id}));
      if (response.statusCode == 202) return null;
      print("Like ${response.statusCode}");
      Product item = Product.fromSwipeCard(items[index].toJson());
      return item;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future dislikeRequest() async {
    print("DISLIKE!!");
    try {
      final response = await _api.client.post('${Api.endpoint}/home/dislike',
          data: jsonEncode({'product_id': items[index].product_id}));
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future purchaseItem(int id) async {
    try {
      await _api.client.post('${Api.endpoint}/home/purchase',
          data: jsonEncode({'product_id': id}));
    } catch (e) {
      _api.errorCreate(Error());
    }
  }
}
