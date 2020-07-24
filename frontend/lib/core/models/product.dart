class Product {
  String product_id;
  String thumbnail_url;
  int price;
  String product_name;
  String product_url;
  String type;
  int selected = 0;
  // String size;

  Product(
      {this.product_id,
      this.thumbnail_url,
      this.price,
      this.product_name,
      this.product_url,
      // this.size,
      this.type});

  Product.fromJson(Map<String, dynamic> json) {
    product_id = json['product_id'];
    thumbnail_url = json['thumbnail_url'];
    price = json['price'];
    product_name = json['product_name'];
    product_url = json['product_url'];
    type = json['type'];
    print(product_url);
    // size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.product_id;
    data['thumbnail_url'] = this.thumbnail_url;
    data['price'] = this.price;
    data['product_name'] = this.product_name;
    data['product_url'] = this.product_url;
    // data['size'] = this.size;
    data['type'] = this.type;
    return data;
  }
}
