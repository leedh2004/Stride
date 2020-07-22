import 'package:flutter/material.dart';
import 'package:frontend/core/models/product.dart';
import 'package:frontend/core/services/api.dart';
import 'package:frontend/core/viewmodels/base_model.dart';

class DressRoomModel extends BaseModel {
  Api _api;
  DressRoomModel({@required Api api}) : _api = api;
  List<Product> items;
  bool flag = false;

  Future fetchItems() async {
    setBusy(true);
    items = await _api.getDressRoom();
    setBusy(false);
  }

  void selectItem(int index) {
    items[index].selected = true;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
