import 'package:app/core/models/product.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/services/swipe.dart';
import 'package:app/core/viewmodels/base_model.dart';

class SwipeModel extends BaseModel {
  DressRoomService dressRoomService;
  SwipeService _swipeService;
  bool trick = false;
  String type;
  int index;
  int image_index = 0;

  SwipeModel(DressRoomService _dressRoomService, SwipeService swipeService) {
    dressRoomService = _dressRoomService;
    _swipeService = swipeService;
    type = _swipeService.type;
    index = swipeService.index[type];
    print("SwipeModel 생성!");
    print(type);
    print(index);
    //print(items[1][0].product_name);
  }

  Future initCards() async {
    await _swipeService.initCards();
    notifyListeners();
  }

  void nextImage() {
    int max_length = _swipeService.items[type][index].image_urls.length - 1;
    if (image_index < max_length) {
      image_index++;
      notifyListeners();
    }
  }

  void prevImage() {
    if (image_index > 0) {
      image_index--;
      notifyListeners();
    }
  }

  void changeType(String str) {
    _swipeService.changeType(str);
    type = _swipeService.type;
    index = _swipeService.index[type];
    image_index = 0;
    notifyListeners();
  }

  void nextItem() async {
    setBusy(true);
    await _swipeService.nextItem();
    index = _swipeService.index[type];
    image_index = 0;
    setBusy(false);
  }

  Future likeRequest() async {
    Product item = await _swipeService.likeRequest();
    await dressRoomService.addItem(item);
  }

  void dislikeRequest() async {
    await _swipeService.dislikeRequest();
  }

  void passRequest() async {
    await _swipeService.passRequest();
  }

  void purchaseItem(int id) async {
    await _swipeService.purchaseItem(id);
  }

  void test() async {
    print("TEST");
    setBusy(true);
    trick = true;
    await Future.delayed(Duration(milliseconds: 500));
    nextItem();
    print('?');
    trick = false;
    setBusy(false);
    notifyListeners();
  }
}
