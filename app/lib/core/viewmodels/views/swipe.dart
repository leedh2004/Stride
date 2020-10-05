import 'package:app/core/models/product.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/base_model.dart';

class SwipeModel extends BaseModel {
  // DressRoomService dressRoomService;
  AuthenticationService _authenticationService;
  SwipeService _swipeService;
  bool trick = false;
  int image_index = 0, index;
  Filter filter;

  SwipeModel(
      SwipeService swipeService, AuthenticationService authenticationService) {
    _authenticationService = authenticationService;
    _swipeService = swipeService;
    index = swipeService.index;
    filter = Filter.from(swipeService.filter);
    print("SwipeModel 생성!");
  }

  Future initCards() async {
    await _swipeService.initCards();
    notifyListeners();
  }

  void setClothTypes(List<String> types) {
    filter.setTypes(types);
  }

  void setConcepts(List<String> types) {
    filter.setConcepts(types);
  }

  void setPrice(int start, int end) {
    filter.setPrice(start, end);
  }

  void setColors(List<String> colors) {
    filter.setColors(colors);
  }

  void setSize(bool value) {
    filter.setSize(value);
  }

  void setFilter() {
    _swipeService.setFilter(filter);
  }

  bool nextImage() {
    int max_length = _swipeService.items[index].image_urls.length - 1;
    if (image_index < max_length) {
      image_index++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool prevImage() {
    if (image_index > 0) {
      image_index--;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future nextItem() async {
    await _swipeService.nextItem();
    index = _swipeService.index;
    image_index = 0;
  }

  void likeRequest() async {
    await _swipeService.likeRequest();
    _authenticationService.addLike();
  }

  void dislikeRequest() async {
    await _swipeService.dislikeRequest();
    _authenticationService.addDislike();
  }

  void purchaseItem(int id) async {
    await _swipeService.purchaseItem(id);
  }

  void test() async {
    setBusy(true);
    // await _swipeService.initSizeCards();
    image_index = 0;

    setBusy(false);
    notifyListeners();
  }
}
