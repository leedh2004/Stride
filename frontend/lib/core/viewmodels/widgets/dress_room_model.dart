import 'package:flutter/material.dart';
import 'package:frontend/core/models/product.dart';
import 'package:frontend/core/services/api.dart';
import 'package:frontend/core/viewmodels/base_model.dart';

class DressRoomModel extends BaseModel {
  Api _api;
  DressRoomModel({@required Api api}) : _api = api;
  List<Product> items;
  bool isAnyOneSelected = false;

  Future fetchItems() async {
    setBusy(true);
    items = await _api.getDressRoom();
    setBusy(false);
  }

  void selectItem(int index) {
    items[index].selected = 1 - items[index].selected; // toggle
    isAnyOneSelected = false;
    for (var item in items) {
      if (item.selected == 1) {
        isAnyOneSelected = true;
        break;
      }
    }
    notifyListeners();
  }

  List<Product> findSelectedTop() {
    List<Product> top = List<Product>();
    for (int i = 0; i < items.length; i++) {
      if (items[i].selected == 1 && items[i].type == 'top') {
        print(items[i].product_name);
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
        print(items[i].product_name);
        bottom.add(items[i]);
      }
    }
    return bottom;
  }

  void removeItem() {
    items.removeWhere((element) => element.selected == 1);
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
