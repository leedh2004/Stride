import 'package:app/core/models/product.dart';
import 'package:app/core/models/product_size.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/ui/shared/text_styles.dart';

class Coordinate {
  int id;
  String name;
  RecentItem top = new RecentItem();
  RecentItem bottom = new RecentItem();

  Coordinate(int _id, String _name, RecentItem _top, RecentItem _bottom) {
    id = _id;
    name = _name;
    top = _top;
    bottom = _bottom;
  }

  Coordinate.fromJson(Map<String, dynamic> json) {
    id = json['coor_id'];
    name = json['coor_name'];
    // print(json);

    top.product_id = json['top_product_id'];
    top.thumbnail_url = json['top_thumbnail_url'];
    top.price = priceText(json['top_price']);
    top.product_name = json['top_product_name'];
    top.product_url = json['top_product_url'];
    top.type = json['top_type'];
    top.shop_name = json['top_shop_name'];
    top.product_size = ProductSize.fromJson(json['top_size']);

    bottom.thumbnail_url = json['bottom_thumbnail_url'];
    bottom.product_name = json['bottom_product_name'];
    bottom.product_id = json['bottom_product_id'];
    bottom.price = priceText(json['bottom_price']);
    bottom.type = json['bottom_type'];
    bottom.product_url = json['bottom_product_url'];
    bottom.shop_name = json['bottom_shop_name'];
    bottom.product_size = ProductSize.fromJson(json['bottom_size']);
  }
}
