import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/viewmodels/base_model.dart';

class DressRoomModel extends BaseModel {
  List<Product> items;
  bool isAnyOneSelected = false;
  Api _api;

  DressRoomModel(List<Product> serviceItems, Api api) {
    print("DressRoomModel 생성!");
    items = serviceItems;
    _api = api;
    for (var item in items) {
      if (item.selected == 1) {
        item.selected = 0;
      }
    }
  }

  List<Product> findSelectedTop() {
    List<Product> top = List<Product>();
    for (int i = 0; i < items.length; i++) {
      if (items[i].selected == 1 && items[i].type == 'top') {
        top.add(items[i]);
      }
    }
    return top;
  }

  List<Product> findSelectedBotoom() {
    List<Product> bottom = List<Product>();
    for (int i = 0; i < items.length; i++) {
      if (items[i].selected == 1 &&
          (items[i].type == 'skirt' || items[i].type == 'pants')) {
        bottom.add(items[i]);
      }
    }
    return bottom;
  }

  void selectItem(int index) {
    items[index].selected = 1 - items[index].selected;
    isAnyOneSelected = false;
    for (var item in items) {
      if (item.selected == 1) {
        isAnyOneSelected = true;
        break;
      }
    }
    notifyListeners();
  }

  void removeItem() async {
    List<int> removedIds = List<int>();
    for (var element in items) {
      if (element.selected == 1) {
        removedIds.add(element.product_id);
      }
    }
    final response = await _api.client.post('${Api.endpoint}/dressroom/delete/',
        data: jsonEncode({'product_id': removedIds}));
    if (response.statusCode == 200) {
      items.removeWhere((element) => element.selected == 1);
    }
    notifyListeners();
  }

  void makeCoordinate(int top, int bottom) async {
    final response = await _api.client.post('${Api.endpoint}/coordination/',
        data: jsonEncode({'top_product_id': top, 'bottom_product_id': bottom}));
    print("makeCoordinate() ${response.statusCode}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
