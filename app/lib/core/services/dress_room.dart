import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'api.dart';

class DressRoomService {
  //BehaviorSubject<List<Product>> _itemsController = BehaviorSubject();
  //Stream<List<Product>> get items => _itemsController.stream;
  List<int> folder_id;
  Map<int, List<Product>> items = new Map();
  Map<int, String> folder = new Map(); // folder_id, folder_name
  Api _api;
  int current_folder = 0;

  //이제 생성자에 아무것도 요청안함
  DressRoomService(Api api) {
    print("DressRoomService 생성!");
    _api = api;
  }
  void changeFolder(int folderId) {
    current_folder = folderId;
  }

  bool isTop(int index) {
    return items[current_folder][index].type == 'top';
  }

  bool isBottom(int index) {
    return (items[current_folder][index].type == 'pants' ||
        items[current_folder][index].type == 'skirt');
  }

  addItem(Product item) async {
    items[current_folder].add(item);
  }

  Future getDressRoom() async {
    var response = await _api.client.get(
      '${Api.endpoint}/dressroom/',
    );
    var parsed = json.decode(response.data) as Map<String, dynamic>;
    print(parsed);
    for (var info in parsed['info']) {
      folder[info['folder_id']] = info['folder_name'];
      var temp = List<Product>();
      for (var item in parsed[folder[info['folder_id']]]) {
        temp.add(Product.fromJson(item));
      }
      items[info['folder_id']] = temp;
    }
    return;
  }

  Future makeCoordinate(int top, int bottom) async {
    final response = await _api.client.post('${Api.endpoint}/coordination/',
        data: jsonEncode({'top_product_id': top, 'bottom_product_id': bottom}));
    print(top);
    print(bottom);
    print("makeCoordinate() ${response.statusCode}");
    return;
  }

  List<Product> findSelectedTop(List<int> selectedIdx) {
    List<Product> ret = new List();
    for (int i = 0; i < selectedIdx.length; i++) {
      int idx = selectedIdx[i];
      if (items[current_folder][idx].type == 'top')
        ret.add(items[current_folder][idx]);
    }
    return ret;
  }

  List<Product> findSelectedBottom(List<int> selectedIdx) {
    List<Product> ret = new List();
    for (int i = 0; i < selectedIdx.length; i++) {
      int idx = selectedIdx[i];
      if (items[current_folder][idx].type == 'skirt' ||
          items[current_folder][idx].type == 'pants')
        ret.add(items[current_folder][idx]);
    }
    return ret;
  }

  Future removeItem(List<int> selectedIdx) async {
    List<int> removeIds = new List();
    for (var idx in selectedIdx)
      removeIds.add(items[current_folder][idx].product_id);
    final response = await _api.client.put('${Api.endpoint}/dressroom/',
        data: jsonEncode({'product_id': removeIds}));
    if (response.statusCode == 200) {
      int cnt = 0;
      var temp = new List<Product>();
      for (int i = 0; i < items[current_folder].length; i++) {
        if (i == selectedIdx[cnt]) {
          cnt++;
          if (cnt == selectedIdx.length) cnt--; // 초과 막음
          continue;
        } else
          temp.add(items[current_folder][i]);
      }
      items[current_folder] = temp;
    } else {
      print("Error ${response.statusCode}");
    }
    return;
  }
}
