import 'package:app/core/services/lookbook.dart';
import 'package:app/core/viewmodels/base_model.dart';

class LookBookModel extends BaseModel {
  LookBookService service;
  Set<int> selectedIdx = new Set();
  int current_folder = 0;

  LookBookModel(LookBookService _service) {
    print("LookBookModel 생성!");
    service = _service;
    current_folder = service.current_folder;
  }

  void changeFolder(int folderId) {
    service.changeFolder(folderId);
    current_folder = service.current_folder;
    selectedIdx.clear();
    notifyListeners();
  }

  Future removeItem(int id) async {
    await service.removeItem(id);
    selectedIdx.clear();
    notifyListeners();
  }

  // Future removeItem() async {
  //   await service.removeItem(selectedIdx.toList());
  //   selectedIdx.clear();
  //   notifyListeners();
  // }

  Future rename(int id, String name) async {
    await service.rename(id, name);
    notifyListeners();
  }

  Future getLookBook() async {
    await service.getLookBook();
    notifyListeners();
  }

  void selectItem(int index) {
    // 그런데 이렇게 하면 모든게 렌더링 될텐데 이게 맞는건가..?
    if (selectedIdx.contains(index)) {
      selectedIdx.remove(index);
    } else {
      selectedIdx.add(index);
    }
    notifyListeners();
  }

  Future createFolder(String folderName) async {
    await service.createFolder(folderName, selectedIdx.toList());
    selectedIdx.clear();
    notifyListeners();
  }

  Future renameFolder(int folderId, String newName) async {
    await service.renameFolder(folderId, newName);
    notifyListeners();
  }

  Future moveFolder(int toId, int itemId) async {
    await service.moveFolder(toId, itemId);
    notifyListeners();
  }

  Future deleteFolder(int folderId) async {
    if (await service.deleteFolder(folderId)) {
      current_folder = service.current_folder;
      notifyListeners();
    }
  }

  // Future removeItem() async {
  //   await _service.removeItem(selectedIdx.toList());
  //   selectedIdx.clear();
  //   notifyListeners();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
