import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';

class DressRoomService {
  BehaviorSubject<List<Product>> _itemsController = BehaviorSubject();
  Stream<List<Product>> get items => _itemsController.stream;
  Api _api;

  DressRoomService(Api api) {
    print("DressRoomService 생성!");
    _api = api;
    getDressRoom();
  }

  void addItem(Product item) async {
    print("HEY!");
    List<Product> last = _itemsController.value;
    _itemsController.add([...last, item]);
  }

  Future<List<Product>> getDressRoom() async {
    var temp = List<Product>();
    var response = await _api.client.get(
      '${Api.endpoint}/dressroom/',
    );
    var parsed = json.decode(response.data) as List<dynamic>;
    for (var item in parsed) {
      temp.add(Product.fromJson(item));
    }
    _itemsController.add(temp);
    return temp;
  }
}
