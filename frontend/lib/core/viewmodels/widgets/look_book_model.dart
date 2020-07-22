import 'package:flutter/material.dart';
import 'package:frontend/core/models/coordinate.dart';
import 'package:frontend/core/services/api.dart';
import 'package:frontend/core/viewmodels/base_model.dart';

class LookBookModel extends BaseModel {
  Api _api;
  LookBookModel({@required Api api}) : _api = api;
  List<Coordinate> items;

  Future fetchItems() async {
    setBusy(true);
    items = await _api.getCoordinate();
    setBusy(false);
  }

  void removeItem(int index) {
    print("$index remove");
    items.removeAt(index);
    notifyListeners();
  }

  void rename(int index, String name) {
    print("$name rename");
    items[index].name = name;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
