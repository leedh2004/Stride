import 'package:frontend/core/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  static const endpoint = 'http://15.165.33.138:5000';
  var client = new http.Client();

  Future<List<Product>> getDressRoom() async {
    var items = List<Product>();
    var response = await client.get('$endpoint/dressroom/test');
    var parsed = json.decode(response.body) as List<dynamic>;
    for (var item in parsed) {
      items.add(Product.fromJson(item));
    }
    //print(items[0]);
    return items;
  }
}
