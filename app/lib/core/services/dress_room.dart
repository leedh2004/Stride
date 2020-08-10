import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class DressRoomService {
  StreamController<List<Product>> _itemsController =
      StreamController<List<Product>>();
  Stream<List<Product>> get items => _itemsController.stream;
  //List<Product> items;
  // AuthenticationService _authenticationService;
  Api _api;
  var client = new http.Client();

  DressRoomService(Api api) {
    print("드레스룸생성!!!!!!");
    _api = api;
    getDressRoom();
  }

  void addItem(List<Product> item) {
    _itemsController.add(item);
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
