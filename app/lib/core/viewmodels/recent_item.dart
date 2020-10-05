import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/recent_item.dart';
import 'package:app/core/viewmodels/base_model.dart';

class RecentItemModel extends BaseModel {
  RecentItemService service;

  RecentItemModel(RecentItemService _service) {
    print("RecentItemModel 생성!");
    service = _service;
  }

  Future<List<RecentItem>> addItem(int page) async {
    List<RecentItem> ret = await service.addItem(page);
    notifyListeners();
    return ret;
  }

  void likeRequest(int id) {
    service.likeRequest(id);
  }

  void dislikeRequest(int id) {
    service.dislikeRequest(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
