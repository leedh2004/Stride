import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/subjects.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class DressRoomService {
  // StreamController<List<Product>> _itemsController =
  //     StreamController<List<Product>>.broadcast();
  // List<Product> items;
  // AuthenticationService _authenticationService;
  BehaviorSubject<List<Product>> _itemsController = BehaviorSubject();
  Stream<List<Product>> get items => _itemsController.stream;
  Api _api;
  var client = new http.Client();
  DressRoomService(Api api) {
    print("드레스룸서비스생성!!!!!!");
    _api = api;
    getDressRoom();
  }
  void addItem(Product item) async {
    //List<Product> temp = items.
    List<Product> last = _itemsController.value;
    _itemsController.add([...last, item]);
  }

  Future<List<Product>> getDressRoom() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'jwt_token');
    var temp = List<Product>();
    var response = await client.get(
      '${Api.endpoint}/dressroom/',
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': "Bearer ${token}",
      },
    );
    //실패시 처리
    var parsed = json.decode(response.body) as List<dynamic>;
    for (var item in parsed) {
      temp.add(Product.fromJson(item));
    }
    _itemsController.add(temp);
    return temp;
  }
}
