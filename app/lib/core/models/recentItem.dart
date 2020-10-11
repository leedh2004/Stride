import 'package:app/core/models/product_size.dart';
import 'package:app/ui/shared/text_styles.dart';

class RecentItem {
  int product_id;
  String thumbnail_url;
  String compressed_thumbnail_url;
  String price;
  String product_name;
  String product_url;
  String type;
  int length;
  bool likes;
  String likes_time;
  List<dynamic> origin_color;
  List<dynamic> clustered_color;

  //int selected = 0;
  List<dynamic> image_urls;
  ProductSize product_size;
  String shop_name;
  // String size;
  RecentItem(
      {this.product_id,
      this.thumbnail_url,
      this.price,
      this.product_name,
      this.product_url,
      this.image_urls,
      this.type});

  RecentItem.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'];
    thumbnail_url = json['thumbnail_url'];
    compressed_thumbnail_url = json['compressed_thumbnail_url'];
    price = priceText(json['price']);
    product_name = json['product_name'];
    product_url = json['product_url'];
    image_urls = json['image_url'];
    origin_color = json['origin_color'];
    clustered_color = json['clustered_color'];
    print(origin_color);
    likes = json['likes'];
    likes_time = json['likes_time'];
    image_urls = [thumbnail_url, ...image_urls];
    length = image_urls.length;
    type = json['type'];
    product_size = ProductSize.fromJson(json['size']);
    shop_name = json['shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.product_id;
    data['thumbnail_url'] = this.thumbnail_url;
    data['price'] = this.price;
    data['product_name'] = this.product_name;
    data['product_url'] = this.product_url;
    data['image_urls'] = this.image_urls;
    data['type'] = this.type;
    data['shop_name'] = this.shop_name;
    data['size'] = this.product_size;
    return data;
  }
}
