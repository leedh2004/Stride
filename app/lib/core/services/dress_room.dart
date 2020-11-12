import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'api.dart';

class DressRoomService {
  //BehaviorSubject<List<RecentItem>> _itemsController = BehaviorSubject();
  //Stream<List<RecentItem>> get items => _itemsController.stream;
  List<int> folder_id;
  Map<int, List<RecentItem>> items = new Map();
  Map<int, String> folder = new Map(); // folder_id, folder_name
  Api _api;
  int current_folder = 0;
  bool init = false;

  //이제 생성자에 아무것도 요청안함
  DressRoomService(Api api) {
    print("DressRoomService 생성!");
    _api = api;
  }
  void changeFolder(int folderId) {
    current_folder = folderId;
  }

  bool isTop(int index) {
    return items[current_folder][index].type == 'top';
  }

  bool isBottom(int index) {
    return (items[current_folder][index].type == 'pants' ||
        items[current_folder][index].type == 'skirt');
  }

  void addItem(RecentItem item) {
    if (!items[0].contains(item))
      items[0] = [item, ...items[0]];
    else
      print("!!");
  }

  Future getDressRoom() async {
    folder_id = new List();
    items = new Map();
    folder = new Map();
    current_folder = 0;
    try {
      var response = await _api.client.get(
        '${Api.endpoint}/v2/dressroom/',
      );
      print(response.statusCode);
      var parsed = json.decode(response.data) as Map<String, dynamic>;
      print(parsed);
      for (var info in parsed['info']) {
        folder[info['folder_id']] = info['folder_name'];
        print(info['folder_name']);
        var temp = List<RecentItem>();
        for (var item in parsed[folder[info['folder_id']]]) {
          temp.add(RecentItem.fromJson(item));
        }
        items[info['folder_id']] = temp;
        for (var item in items[info['folder_id']]) {
          print('-------');
          print(item.likes);
          print('-------');
        }
      }
      init = true;
      return;
    } catch (e) {
      print(e.toString());
      _api.errorCreate(Error());
    }
  }

  // Future getDressRoomPage(int pageCount) async {
  //   // folder_id = new List();
  //   // items = new Map();
  //   // folder = new Map();
  //   // current_folder = 0;
  //   print("GETDRESSROOMPAGE");
  //   try {
  //     var response = await _api.client.get(
  //       '${Api.endpoint}/v2/dressroom/folder?order=$pageCount&folder_id=$current_folder&idx=0',
  //     );
  //     print(response.data);
  //     var temp = List<RecentItem>();
  //     var parsed = json.decode(response.data) as List<dynamic>;
  //     for (var item in parsed) {
  //       temp.add(RecentItem.fromJson(item));
  //     }
  //     items[current_folder] = [...items[current_folder], ...temp];
  //     return;
  //   } catch (e) {
  //     print(e.toString());
  //     _api.errorCreate(Error());
  //   }
  // }

  Future makeCoordinate(int top, int bottom) async {
    try {
      final response = await _api.client.post(
          '${Api.endpoint}/v2/coordination/',
          data:
              jsonEncode({'top_product_id': top, 'bottom_product_id': bottom}));
      // print("wtf");
      print("$top $bottom");
      print(response.statusCode);
    } catch (e) {
      _api.errorCreate(Error());
    }
    return;
  }

  List<RecentItem> findSelectedTop(List<int> selectedIdx) {
    List<RecentItem> ret = new List();
    for (int i = 0; i < selectedIdx.length; i++) {
      int idx = selectedIdx[i];
      if (items[current_folder][idx].type == 'top')
        ret.add(items[current_folder][idx]);
    }
    return ret;
  }

  List<RecentItem> findSelectedBottom(List<int> selectedIdx) {
    List<RecentItem> ret = new List();
    for (int i = 0; i < selectedIdx.length; i++) {
      int idx = selectedIdx[i];
      if (items[current_folder][idx].type == 'skirt' ||
          items[current_folder][idx].type == 'pants')
        ret.add(items[current_folder][idx]);
    }
    return ret;
  }

  Future removeItem(List<int> selectedIdx) async {
    List<int> removeIds = new List();
    for (var idx in selectedIdx)
      removeIds.add(items[current_folder][idx].product_id);
    try {
      final response = await _api.client.put('${Api.endpoint}/v2/dressroom/',
          data: jsonEncode({'product_id': removeIds}));
      int cnt = 0;
      var temp = new List<RecentItem>();
      selectedIdx.sort();
      for (int i = 0; i < items[current_folder].length; i++) {
        if (i == selectedIdx[cnt]) {
          cnt++;
          if (cnt == selectedIdx.length) cnt--; // 초과 막음
          continue;
        } else {
          temp.add(items[current_folder][i]);
        }
      }
      items[current_folder] = temp;
    } catch (e) {
      _api.errorCreate(Error());
    }
    return;
  }

  Future createFolder(String folderName, List<int> selectedIdx) async {
    List<int> selectedIds = new List();
    List<RecentItem> selectedProduct = new List();
    for (var idx in selectedIdx) {
      selectedIds.add(items[current_folder][idx].product_id);
      selectedProduct.add(items[current_folder][idx]);
    }
    try {
      var response;
      if (selectedIds.length == 0) {
        response = await _api.client.post('${Api.endpoint}/v2/dressroom/folder',
            data: jsonEncode({'product_id': -1, 'folder_name': folderName}));
      } else {
        response = await _api.client.post('${Api.endpoint}/v2/dressroom/folder',
            data: jsonEncode(
                {'product_id': selectedIds, 'folder_name': folderName}));
      }
      var parsed = json.decode(response.data) as Map<String, dynamic>;
      int newId = parsed['folder_id'];
      print(newId);
      folder[newId] = folderName;
      items[newId] = selectedProduct;
      for (var item in selectedProduct) {
        items[current_folder].remove(item);
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future<bool> deleteFolder(int folderId) async {
    try {
      if (folderId == current_folder) {
        current_folder = 0;
      }
      final response = await _api.client
          .delete('${Api.endpoint}/v2/dressroom/folder?folder_id=${folderId}');
      folder.remove(folderId);
      items.remove(folderId);
      return true;
    } catch (e) {
      _api.errorCreate(Error());
    }
    return false;
  }

  Future renameFolder(int folderId, String newName) async {
    try {
      final response = await _api.client.put(
          '${Api.endpoint}/v2/dressroom/folder/name',
          data: jsonEncode({'folder_id': folderId, 'update_name': newName}));
      folder[folderId] = newName;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future moveFolder(int toId, List<int> selectedIdx) async {
    List<int> selectedIds = new List();
    List<RecentItem> selectedProduct = new List();
    for (var idx in selectedIdx) {
      selectedIds.add(items[current_folder][idx].product_id);
      selectedProduct.add(items[current_folder][idx]);
    }
    try {
      var response = await _api.client.put(
          '${Api.endpoint}/v2/dressroom/folder/move',
          data: jsonEncode({'folder_id': toId, 'product_id': selectedIds}));
      items[toId] = [...items[toId], ...selectedProduct];
      for (var item in selectedProduct) {
        items[current_folder].remove(item);
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }
}
