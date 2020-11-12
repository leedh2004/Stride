import 'package:app/core/models/size.dart';

class ProductSize {
  Map<String, Size> size = new Map();
  ProductSize.fromJson(Map<String, dynamic> json) {
    if (json['free'] != null) {
      size['free'] = Size.fromJson(json['free']);
    }
    if (json['xs'] != null) {
      size['xs'] = Size.fromJson(json['xs']);
    }
    if (json['s'] != null) {
      size['s'] = Size.fromJson(json['s']);
    }
    if (json['m'] != null) {
      size['m'] = Size.fromJson(json['m']);
    }
    if (json['l'] != null) {
      size['l'] = Size.fromJson(json['l']);
    }
    if (json['xl'] != null) {
      size['xl'] = Size.fromJson(json['xl']);
    }
  }
}
