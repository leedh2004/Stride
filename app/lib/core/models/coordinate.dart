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
    top.image_urls = json['top_image_url'];
    top.origin_color = json['top_origin_color'];
    top.clustered_color = json['top_clustered_color'];
    top.likes = json['top_likes'];
    top.shop_concept = json['top_shop_concept'];

    top.image_urls = [top.thumbnail_url, ...top.image_urls];
    top.length = top.image_urls.length;

    top.type = json['top_type'];
    top.shop_name = json['top_shop_name'];
    top.product_size = ProductSize.fromJson(json['top_size']);
    top.compressed_thumbnail_url = json['top_compressed_thumbnail_url'];

    bottom.thumbnail_url = json['bottom_thumbnail_url'];
    bottom.product_name = json['bottom_product_name'];
    bottom.product_id = json['bottom_product_id'];
    bottom.price = priceText(json['bottom_price']);
    bottom.type = json['bottom_type'];
    bottom.product_url = json['bottom_product_url'];
    bottom.shop_name = json['bottom_shop_name'];
    bottom.product_size = ProductSize.fromJson(json['bottom_size']);
    bottom.compressed_thumbnail_url = json['bottom_compressed_thumbnail_url'];
    bottom.shop_concept = json['bottom_shop_concept'];

    bottom.image_urls = json['bottom_image_url'];
    bottom.origin_color = json['bottom_origin_color'];
    bottom.clustered_color = json['bottom_clustered_color'];
    bottom.likes = json['bottom_likes'];
    bottom.image_urls = [bottom.thumbnail_url, ...bottom.image_urls];
    bottom.length = bottom.image_urls.length;
  }
}
