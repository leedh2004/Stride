class Size {
  Map<String, double> map = new Map();
  Size.fromJson(Map<String, dynamic> json) {
    map['length'] = json['length'] ?? 0;
    map['hem'] = json['hem'] ?? 0;
    map['shoulder'] = json['shoulder'] ?? 0;
    map['bust'] = json['bust'] ?? 0;
    map['waist'] = json['waist'] ?? 0;
    map['hip'] = json['hip'] ?? 0;
    map['thigh'] = json['thigh'] ?? 0;
    map['arm_length'] = json['arm_length'] ?? 0;
    map['rise'] = json['rise'] ?? 0;
  }
}
