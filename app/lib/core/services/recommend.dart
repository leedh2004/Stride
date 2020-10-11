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
        print("!!!!!!!!!200zz");
        print(response);
        var parsed = json.decode(response.data) as Map<String, dynamic>;
        List<RecentItem> temp = new List();
        for (var item in parsed['recommend']) {
          temp.add(RecentItem.fromJson(item));
        }
        recommendItems = temp;
        temp = [];
        for (var item in parsed['new_arrive']) {
          temp.add(RecentItem.fromJson(item));
        }
        newArriveItems = temp;
        temp = [];
        var double_parsed = parsed['concept1'] as Map<String, dynamic>;
        conceptA = double_parsed['concept_name'];
        for (var item in double_parsed['product']) {
          temp.add(RecentItem.fromJson(item));
        }
        conceptItemA = temp;
        temp = [];
        double_parsed = parsed['concept2'] as Map<String, dynamic>;
        conceptB = double_parsed['concept_name'];
        for (var item in double_parsed['product']) {
          temp.add(RecentItem.fromJson(item));
        }
        conceptItemB = temp;
        temp = [];
        init = true;
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }
}
