import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/product.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class LookBookService {
  List<Coordinate> items;
  Api _api;

  LookBookService(Api api) {
    print("LookBookService 생성!");
    _api = api;
  }

  Future addItem(Product top, Product bottom) async {
    try {
      print(top.product_id);
      print(bottom.product_id);

      final response = await _api.client.post('${Api.endpoint}/coordination/',
          data: jsonEncode({
            'top_product_id': top.product_id,
            'bottom_product_id': bottom.product_id,
            'name': '나만의 룩'
          }));
      if (response.statusCode == 200) {
        int coor_id = json.decode(response.data)["coor_id"];
        // List<Coordinate> last = _itemsController.value;
        Coordinate item = new Coordinate(coor_id, "나만의 룩", top, bottom);
        items.add(item);
      }
    } catch (e) {
      if (e is DioError) {
        print('Error ${e.response.statusCode}');
      }
    }
  }

  Future getLookBook() async {
    var temp = List<Coordinate>();
    var response = await _api.client.get(
      '${Api.endpoint}/coordination/',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(Coordinate.fromJson(item));
    }
    items = temp;
    print("?");
  }

  Future rename(int index, String name) async {
    final response = await _api.client.put('${Api.endpoint}/coordination/',
        data: jsonEncode({'coor_id': items[index].id, 'update_name': name}));
    print("rename ${response.statusCode}");
    if (response.statusCode == 200) {
      items[index].name = name;
    }
  }

  Future removeItem(int id) async {
    final response =
        await _api.client.delete('${Api.endpoint}/coordination?coor_id=${id}');
    print("removeItem ${response.statusCode}");
    if (response.statusCode == 200) {
      items.removeWhere((element) => element.id == id);
    }
  }
}
