import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/tutorial.dart';
import 'api.dart';

class TutorialService {
  Api _api;

  TutorialService(Api api) {
    _api = api;
  }

  Future<bool> sendBirth(int birth) async {
    var response = await _api.client
        .post('${Api.endpoint}/user/birth', data: jsonEncode({'birth': birth}));
    if (response.statusCode == 200) return true;
    return false;
  }

  //허리, 엉덩이, 허벅지, 어깨, 가슴 순서
  Future<bool> sendSize(
      List<RangeWrapper> ranges, List<FlagWrapper> flags) async {
    List<int> waistRange = flags[0].value
        ? [ranges[0].value.start.toInt(), ranges[0].value.end.toInt()]
        : null;
    List<int> hipRange = flags[1].value
        ? [ranges[1].value.start.toInt(), ranges[1].value.end.toInt()]
        : null;
    ;
    List<int> thighRange = flags[2].value
        ? [ranges[2].value.start.toInt(), ranges[2].value.end.toInt()]
        : null;
    ;
    List<int> shoulderRange = flags[3].value
        ? [ranges[3].value.start.toInt(), ranges[3].value.end.toInt()]
        : null;
    ;
    List<int> bustRange = flags[4].value
        ? [ranges[4].value.start.toInt(), ranges[4].value.end.toInt()]
        : null;
    ;
    var send = {
      'size': {
        'thigh': thighRange, // []
        'hip': hipRange, // [30, 40]
        'bust': bustRange,
        'shoulder': shoulderRange,
        'waist': waistRange
      }
    };
    var response = await _api.client
        .post('${Api.endpoint}/user/size', data: jsonEncode(send));
    if (response.statusCode == 200) return true;
    return false;
  }
}
