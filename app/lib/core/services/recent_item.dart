import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:rxdart/rxdart.dart';
import 'api.dart';

class RecentItemService {
  // BehaviorSubject<List<SwipeCard>> itemController = BehaviorSubject();
  // Stream<List<SwipeCard>> get items => itemController.stream;
  Api _api;

  RecentItemService(Api api) {
    print("RecentItemService 생성!");
    // itemController.add([]);
    _api = api;
  }

  Future addItem(int page) async {
    try {
      final response =
          await _api.client.get('${Api.endpoint}/user/history/$page');
      if (response.statusCode == 200) {
        print(response);
        var parsed = json.decode(response.data) as List<dynamic>;
        List<RecentItem> temp = List();
        for (var item in parsed) {
          temp.add(RecentItem.fromJson(item));
        }
        return temp;
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future revertAndLikeRequest(int id) async {
    try {
      final response = await _api.client
          .put('${Api.endpoint}/user/history', data: {'product_id': id});
      if (response.statusCode == 200) {
        print(response);
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future likeRequest(int id) async {
    final response = await _api.client.post('${Api.endpoint}/v2/home/like',
        data: jsonEncode({'product_id': id}));
    print(response.statusCode);
  }

  Future revertAndDislikeRequest(int id) async {
    try {
      final response = await _api.client
          .put('${Api.endpoint}/user/history', data: {'product_id': id});
      if (response.statusCode == 200) {
        print(response);
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future dislikeRequest(int id) async {
    final response = await _api.client.post('${Api.endpoint}/v2/home/dislike',
        data: jsonEncode({'product_id': id}));
  }
}
