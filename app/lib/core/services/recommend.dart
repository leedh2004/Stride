import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/recentItem.dart';
import 'api.dart';

class RecommendationService {
  Api _api;
  bool init = false;
  List<RecentItem> recommendItems = new List();
  List<RecentItem> newArriveItems = new List();
  List<RecentItem> conceptItemA = new List();
  List<RecentItem> conceptItemB = new List();
  String conceptA;
  String conceptB;

  RecommendationService(Api api) {
    print("RecommendationService 생성!");
    _api = api;
  }

  Future initalize() async {
    try {
      final response =
          await _api.client.get('${Api.endpoint}/v2/recommendation');
      if (response.statusCode == 200) {
        print(response);
        var parsed = json.decode(response.data) as Map<String, dynamic>;
        for (var item in parsed['recommend']) {
          recommendItems.add(RecentItem.fromJson(item));
        }
        for (var item in parsed['new_arrive']) {
          newArriveItems.add(RecentItem.fromJson(item));
        }
        var double_parsed = parsed['concept1'] as Map<String, dynamic>;
        conceptA = double_parsed['concept_name'];
        for (var item in double_parsed['product']) {
          conceptItemA.add(RecentItem.fromJson(item));
        }
        double_parsed = parsed['concept2'] as Map<String, dynamic>;
        conceptB = double_parsed['concept_name'];
        for (var item in double_parsed['product']) {
          conceptItemB.add(RecentItem.fromJson(item));
        }
        init = true;
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }
}
