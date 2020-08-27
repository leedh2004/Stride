import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/viewmodels/base_model.dart';

class LookBookModel extends BaseModel {
  LookBookService service;

  LookBookModel(LookBookService _service) {
    print("LookBookModel 생성!");
    service = _service;
  }

  Future removeItem(int id) async {
    await service.removeItem(id);
    notifyListeners();
  }

  Future rename(int index, String name) async {
    await service.rename(index, name);
    notifyListeners();
  }

  Future getLookBook() async {
    await service.getLookBook();
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
