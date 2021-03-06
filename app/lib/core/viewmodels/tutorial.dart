import 'package:app/core/services/tutorial.dart';
import 'package:app/core/viewmodels/base_model.dart';

class TutorialModel extends BaseModel {
  TutorialService service;
  Set<int> selected = new Set();

  TutorialModel(TutorialService _service) {
    print("TutorialModel 생성!");
    service = _service;
  }

  Future getItem() async {
    // setBusy(true);
    await service.getItem();
    notifyListeners();
    // setBusy(false);
  }

  void addItem(int id) async {
    selected.add(id);
    notifyListeners();
  }

  void removeItem(int id) async {
    selected.remove(id);
    notifyListeners();
  }

  Future sendItems() async {
    await service.sendItems(selected.toList());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("I am dispose");
    super.dispose();
  }
}
