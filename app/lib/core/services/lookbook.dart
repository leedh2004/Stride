import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/product.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class LookBookService {
  BehaviorSubject<List<Coordinate>> _itemsController = BehaviorSubject();
  Stream<List<Coordinate>> get items => _itemsController.stream;
  Api _api;

  LookBookService(Api api) {
    print("LookBookService 생성!");
    _api = api;
  }

  void addItem(Product top, Product bottom) async {
    try {
      final response = await _api.client.post('${Api.endpoint}/coordination/',
          data: jsonEncode({
            'top_product_id': top.product_id,
            'bottom_product_id': bottom.product_id,
            'name': '나만의 룩'
          }));
      if (response.statusCode == 200) {
        int coor_id = json.decode(response.data)["coor_id"];
        List<Coordinate> last = _itemsController.value;
        Coordinate item = new Coordinate(coor_id, "나만의 룩", top, bottom);
        _itemsController.add([...last, item]);
        print("!");
      }
    } catch (e) {
      if (e is DioError) {
        print('Error ${e.response.statusCode}');
      }
    }
  }

  Future<List<Coordinate>> getLookBook() async {
    var temp = List<Coordinate>();
    var response = await _api.client.get(
      '${Api.endpoint}/coordination/',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(Coordinate.fromJson(item));
    }
    _itemsController.add(temp);
    return temp;
  }
}
