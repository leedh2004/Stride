import 'package:app/core/models/product.dart';
import 'package:app/ui/shared/text_styles.dart';

class Coordinate {
  int id;
  String name;
  Product top = new Product();
  Product bottom = new Product();

  Coordinate(int _id, String _name, Product _top, Product _bottom) {
    id = _id;
    name = _name;
    top = _top;
    bottom = _bottom;
  }

  Coordinate.fromJson(Map<String, dynamic> json) {
    id = json['coor_id'];
    name = json['coor_name'];
    top.thumbnail_url = json['top_thumbnail_url'];
    top.product_name = json['top_product_name'];
    top.product_id = json['top_product_id'];
    top.price = priceText(json['top_price']);
    top.type = json['top_type'];
    top.product_url = json['top_product_url'];
    bottom.thumbnail_url = json['bottom_thumbnail_url'];
    bottom.product_name = json['bottom_product_name'];
    bottom.product_id = json['bottom_product_id'];
    bottom.price = priceText(json['bottom_price']);
    bottom.type = json['bottom_type'];
    bottom.product_url = json['bottom_product_url'];
  }
}
