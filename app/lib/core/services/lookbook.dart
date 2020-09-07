import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/product.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class LookBookService {
  List<Coordinate> items;
  Api _api;
  bool init = false;

  LookBookService(Api api) {
    print("LookBookService 생성!");
    _api = api;
  }

  Future addItem(Product top, Product bottom) async {
    try {
      final response = await _api.client.post('${Api.endpoint}/coordination/',
          data: jsonEncode({
            'top_product_id': top.product_id,
            'bottom_product_id': bottom.product_id,
            'name': '나만의 룩'
          }));
      int coor_id = json.decode(response.data)["coor_id"];
      Coordinate item = new Coordinate(coor_id, "나만의 룩", top, bottom);
      items.add(item);
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future getLookBook() async {
    var temp = List<Coordinate>();
    try {
      var response = await _api.client.get(
        '${Api.endpoint}/coordination/',
      );
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        temp.add(Coordinate.fromJson(item));
      }
      items = temp;
      init = true;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future rename(int index, String name) async {
    try {
      final response = await _api.client.put('${Api.endpoint}/coordination/',
          data: jsonEncode({'coor_id': items[index].id, 'update_name': name}));
      items[index].name = name;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future removeItem(int id) async {
    try {
      final response = await _api.client
          .delete('${Api.endpoint}/coordination?coor_id=${id}');
      items.removeWhere((element) => element.id == id);
    } catch (e) {
      _api.errorCreate(Error());
    }
  }
}
