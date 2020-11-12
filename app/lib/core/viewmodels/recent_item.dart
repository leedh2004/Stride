import 'package:app/core/models/recentItem.dart';
import 'package:app/core/models/swipeCard.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/lookbook.dart';
import 'package:app/core/services/recent_item.dart';
import 'package:app/core/viewmodels/base_model.dart';

class RecentItemModel extends BaseModel {
  RecentItemService service;
  AuthenticationService auth_service;

  RecentItemModel(
      RecentItemService _service, AuthenticationService _auth_service) {
    print("RecentItemModel 생성!");
    auth_service = _auth_service;
    service = _service;
  }

  Future<List<RecentItem>> addItem(int page) async {
    List<RecentItem> ret = await service.addItem(page);
    notifyListeners();
    return ret;
  }

  void likeRequest(int id) {
    service.likeRequest(id);
    auth_service.addLike();
  }

  void revertAndLikeRequest(int id) {
    service.revertAndLikeRequest(id);
    auth_service.addLike();
    auth_service.minusDislike();
  }

  void dislikeRequest(int id) {
    service.dislikeRequest(id);
    auth_service.addDislike();
  }

  void revertAndDislikeRequest(int id) {
    service.revertAndDislikeRequest(id);
    auth_service.addDislike();
    auth_service.minusLike();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
