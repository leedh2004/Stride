import 'package:frontend/core/models/product.dart';

class Coordinate {
  // Product top;
  // Product bottom;
  String name = "나만의 룩";
  String top_thumbnail_url;
  String top_product_name;
  String top_product_id;
  int top_price;
  String top_type;
  String top_product_url;
  String bottom_thumbnail_url;
  String bottom_product_name;
  String bottom_product_id;
  int bottom_price;
  String bottom_type;
  String bottom_product_url;

  Coordinate.fromJson(Map<String, dynamic> json) {
    top_thumbnail_url = json['top_thumbnail_url'];
    top_product_name = json['top_product_name'];
    top_product_id = json['top_product_id'];
    top_price = json['top_price'];
    top_type = json['top_type'];
    top_product_url = json['top_product_url'];

    bottom_thumbnail_url = json['bottom_thumbnail_url'];
    bottom_product_name = json['bottom_product_name'];
    bottom_product_id = json['bottom_product_id'];
    bottom_price = json['bottom_price'];
    bottom_type = json['bottom_type'];
    bottom_product_url = json['bottom_product_url'];
    // size는 추후에..
  }

  //Map<String, dynamic> toJson() {}
}
