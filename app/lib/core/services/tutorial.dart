import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/tutorial.dart';
import 'package:app/core/models/tutorial_box.dart';
import 'api.dart';

class TutorialService {
  Api _api;
  bool init = false;
  List<TutorialBox> items;

  TutorialService(Api api) {
    _api = api;
  }

  Future getItem() async {
    var response = await _api.client.get('${Api.endpoint}/tutorial');
    List<TutorialBox> ret = new List();
    if (response.statusCode == 200) {
      print(response.data);
      var parsed = json.decode(response.data) as List<dynamic>;
      for (var item in parsed) {
        ret.add(TutorialBox(item['product_id'], item['thumbnail_url']));
      }
      items = ret;
      init = true;
    }
  }

  Future sendItems(List<int> ids) async {
    var response = await _api.client.post('${Api.endpoint}/tutorial',
        data: jsonEncode({'product_id': ids}));
    print(response.statusCode);
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
    try {
      var response = await _api.client
          .post('${Api.endpoint}/user/size', data: jsonEncode(send));
      return true;
    } catch (e) {
      _api.errorCreate(Error());
      return false;
    }
  }
}
