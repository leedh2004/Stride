import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:app/core/services/authentication_service.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/base_model.dart';

class SwipeModel extends BaseModel {
  DressRoomService dressRoomService;
  AuthenticationService _authenticationService;
  SwipeService _swipeService;
  DressRoomService _dressRoomService;
  bool trick = false;
  int image_index = 0, index;
  Filter filter;

  SwipeModel(SwipeService swipeService, DressRoomService dressRoomService,
      AuthenticationService authenticationService) {
    _authenticationService = authenticationService;
    _swipeService = swipeService;
    _dressRoomService = dressRoomService;
    index = _swipeService.index;
    filter = Filter.from(_swipeService.filter);
    print("SwipeModel 생성!");
  }

  Future initCards() async {
    await _swipeService.initCards();
    notifyListeners();
  }

  bool isNotChangedFilter(int index) {
    return _swipeService.isNotchangedFilter(index);
  }

  bool allNotChangedFilter() {
    return filter.allNotchangedFilter();
  }

  void setInitFilter() {
    filter.setTypes(['all']);
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

  void setFilter() async {
    setBusy(true);
    await _swipeService.setFilter(filter);
    image_index = 0;
    index = _swipeService.index;
    setBusy(false);
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
    // notifyListeners();
  }

  void likeRequest() async {
    _swipeService.likeRequest();
    _authenticationService.addLike();
  }

  void dislikeRequest() async {
    _swipeService.dislikeRequest();
    _authenticationService.addDislike();
  }

  void collectRequest() async {
    _swipeService.likeRequest();
    _swipeService.collectRequest();

    _authenticationService.addLike();
  }

  void purchaseItem(int id) async {
    await _swipeService.purchaseItem(id);
  }

  void test() async {
    setBusy(true);
    // await _swipeService.initSizeCards();
    image_index = 0;

    setBusy(false);
    // notifyListeners();
  }

  void addItem(RecentItem item) async {
    _dressRoomService.addItem(item);
  }
}
