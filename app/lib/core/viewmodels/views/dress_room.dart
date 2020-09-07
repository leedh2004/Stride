import 'package:app/core/models/product.dart';
import 'package:app/core/services/dress_room.dart';
import 'package:app/core/viewmodels/base_model.dart';

class DressRoomModel extends BaseModel {
  //List<Product> items;
  DressRoomService _service;
  Set<int> selectedIdx = new Set();
  int top_cnt = 0;
  int bottom_cnt = 0;
  int current_folder = 0;

  DressRoomModel(DressRoomService service) {
    print("DressRoomModel 생성!");
    _service = service;
    current_folder = service.current_folder;
  }

  void changeFolder(int folderId) {
    _service.changeFolder(folderId);
    current_folder = _service.current_folder;
    selectedIdx.clear();
    notifyListeners();
  }

  Future getDressRoom() async {
    await _service.getDressRoom();
    notifyListeners();
  }

  List<Product> findSelectedTop() {
    List<Product> top = _service.findSelectedTop(selectedIdx.toList());
    return top;
  }

  List<Product> findSelectedBotoom() {
    List<Product> bottom = _service.findSelectedBottom(selectedIdx.toList());
    return bottom;
  }

  void selectItem(int index) {
    // 그런데 이렇게 하면 모든게 렌더링 될텐데 이게 맞는건가..?
    if (selectedIdx.contains(index)) {
      if (_service.isTop(index))
        top_cnt--;
      else if (_service.isBottom(index)) bottom_cnt--;
      selectedIdx.remove(index);
    } else {
      if (_service.isTop(index))
        top_cnt++;
      else if (_service.isBottom(index)) bottom_cnt++;
      selectedIdx.add(index);
    }
    notifyListeners();
  }

  Future removeItem() async {
    await _service.removeItem(selectedIdx.toList());
    selectedIdx.clear();
    notifyListeners();
  }

  Future makeCoordinate(int top, int bottom) async {
    // API 콜이니까 드레스룸 서비스에서 하는게 맞는듯
    await _service.makeCoordinate(top, bottom);
    print(top);
    selectedIdx.clear();
  }

  Future createFolder(String folderName) async {
    await _service.createFolder(folderName, selectedIdx.toList());
    selectedIdx.clear();
    notifyListeners();
  }

  Future renameFolder(int folderId, String newName) async {
    await _service.renameFolder(folderId, newName);
    notifyListeners();
  }

  Future moveFolder(int toId) async {
    await _service.moveFolder(toId, selectedIdx.toList());
    selectedIdx.clear();
    notifyListeners();
  }

  Future deleteFolder(int folderId) async {
    if (await _service.deleteFolder(folderId)) {
      print("!!!!!!!!!!!!!!!!!!!!");
      notifyListeners();
    } else {
      print("delete 서버 실패");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
