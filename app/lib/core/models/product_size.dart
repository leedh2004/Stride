import 'package:app/core/models/size.dart';

class ProductSize {
  Size free, xs, s, m, l, xl;
  ProductSize.fromJson(Map<String, dynamic> json) {
    if (json['free'] != null) {
      free = Size.fromJson(json['free']);
    }
    if (json['xs'] != null) {
      xs = Size.fromJson(json['xs']);
    }
    if (json['s'] != null) {
      s = Size.fromJson(json['s']);
    }
    if (json['m'] != null) {
      m = Size.fromJson(json['m']);
    }
    if (json['l'] != null) {
      l = Size.fromJson(json['l']);
    }
    if (json['xl'] != null) {
      xl = Size.fromJson(json['xl']);
    }
  }
}
