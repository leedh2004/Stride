class Size {
  double length, hem, shoulder, bust, waist, hip, thigh;
  Size.fromJson(Map<String, dynamic> json) {
    length = json['length'] ?? 0;
    hem = json['hem'] ?? 0;
    shoulder = json['shoulder'] ?? 0;
    bust = json['bust'] ?? 0;
    waist = json['waist'] ?? 0;
    hip = json['hip'] ?? 0;
    thigh = json['thigh'] ?? 0;
  }
}
