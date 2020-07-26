import 'package:flutter/material.dart';
import 'package:frontend/core/models/product.dart';
import 'package:frontend/core/services/api.dart';
import 'package:frontend/core/viewmodels/base_model.dart';

class SwipeModel extends BaseModel {
  Api _api;
  SwipeModel({@required Api api}) : _api = api;
  List<Product> items;
  int curIdx = 0;

  Future fetchItems() async {
    setBusy(true);
    items = await _api.getDressRoom();
    setBusy(false);
  }

  void nextItem() {
    setBusy(true);
    curIdx++;
    setBusy(false);
  }
}
