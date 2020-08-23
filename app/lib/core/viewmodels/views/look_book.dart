import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/services/api.dart';
import 'package:app/core/viewmodels/base_model.dart';

class LookBookModel extends BaseModel {
  Api _api;
  List<Coordinate> items;

  LookBookModel(List<Coordinate> serviceItems, Api api) {
    print("LookBookModel 생성!");
    items = serviceItems;
    _api = api;
  }

  void removeItem(int id) async {
    final response = await _api.client.post(
        '${Api.endpoint}/coordination/delete',
        data: jsonEncode({'coor_id': id}));
    print("removeItem ${response.statusCode}");
    if (response.statusCode == 200) {
      items.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  void rename(int index, String name) async {
    final response = await _api.client.put('${Api.endpoint}/coordination/',
        data: jsonEncode({'coor_id': items[index].id, 'update_name': name}));
    print("rename ${response.statusCode}");
    if (response.statusCode == 200) {
      items[index].name = name;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
