import 'dart:async';
import 'dart:convert';
import 'package:app/core/models/coordinate.dart';
import 'package:app/core/models/product.dart';
import 'package:app/core/models/recentItem.dart';
import 'package:dio/dio.dart';
import 'api.dart';

class LookBookService {
  List<int> folder_id;
  Map<int, List<Coordinate>> items = new Map();
  Map<int, String> folder = new Map(); // folder_id, folder_name
  // List<Coordinate> items;
  Api _api;
  int current_folder = 0;
  bool init = false;

  LookBookService(Api api) {
    print("LookBookService 생성!");
    _api = api;
  }

  void changeFolder(int folderId) {
    current_folder = folderId;
  }

  Future addItem(RecentItem top, RecentItem bottom, String name) async {
    try {
      print(top.product_name);
      print(bottom.product_name);

      final response =
          await _api.client.post('${Api.endpoint}/v2/coordination/',
              data: jsonEncode({
                'top_product_id': top.product_id,
                'bottom_product_id': bottom.product_id,
                'name': name
              }));
      if (response.statusCode == 200) {
        int coor_id = json.decode(response.data)["coor_id"];
        print("!");
        Coordinate item = new Coordinate(coor_id, name, top, bottom);
        print("!!");
        print(items[0]);
        print(item);
        items[0] = [item, ...items[0]];
        print("!!!");
      }
    } catch (e) {
      print("?????????????/");
      _api.errorCreate(Error());
    }
  }

  Future getLookBook() async {
    folder_id = new List();
    // items = new Map();
    print("!!!!!!!!!!!!!!!!!!!!@@@@@@@@@@@@#!@#?@!#?#@!?#@!?");
    // folder = new Map();
    current_folder = 0;
    try {
      var response = await _api.client.get(
        '${Api.endpoint}/v2/coordination/',
      );
      var parsed = json.decode(response.data) as Map<String, dynamic>;
      print(parsed);
      for (var info in parsed['info']) {
        folder[info['folder_id']] = info['folder_name'];
        var temp = List<Coordinate>();
        for (var item in parsed[folder[info['folder_id']]]) {
          temp.add(Coordinate.fromJson(item));
        }
        print(info['folder_id']);
        items[info['folder_id']] = temp;
      }
      init = true;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future rename(int index, String name) async {
    try {
      final response = await _api.client.put('${Api.endpoint}/v2/coordination/',
          data: jsonEncode({
            'coor_id': items[current_folder][index].id,
            'update_name': name
          }));
      items[current_folder][index].name = name;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future removeItem(List<int> selectedIdx) async {
    List<int> removeIds = new List();
    for (var idx in selectedIdx) removeIds.add(items[current_folder][idx].id);
    try {
      final response = await _api.client.put('${Api.endpoint}/v2/coordination/',
          data: jsonEncode({'coor_id': removeIds}));
      int cnt = 0;
      var temp = new List<Coordinate>();
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
  }

  Future createFolder(String folderName, List<int> selectedIdx) async {
    List<int> selectedIds = new List();
    List<Coordinate> selcetedCoordinate = new List();
    for (var idx in selectedIdx) {
      selectedIds.add(items[current_folder][idx].id);
      selcetedCoordinate.add(items[current_folder][idx]);
    }
    try {
      var response;
      if (selectedIds.length == 0) {
        response = await _api.client.post(
            '${Api.endpoint}/v2/coordination/folder',
            data: jsonEncode({'coor_id': -1, 'folder_name': folderName}));
      } else {
        response = await _api.client.post(
            '${Api.endpoint}/v2/coordination/folder',
            data: jsonEncode(
                {'coor_id': selectedIds, 'folder_name': folderName}));
      }
      print(response.statusCode);
      var parsed = json.decode(response.data) as Map<String, dynamic>;
      int newId = parsed['folder_id'];
      print(newId);
      folder[newId] = folderName;
      items[newId] = selcetedCoordinate;
      for (var item in selcetedCoordinate) {
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
      final response = await _api.client.delete(
          '${Api.endpoint}/v2/coordination/folder?folder_id=${folderId}');
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
          '${Api.endpoint}/v2/coordination/folder/name',
          data: jsonEncode({'folder_id': folderId, 'update_name': newName}));
      folder[folderId] = newName;
    } catch (e) {
      _api.errorCreate(Error());
    }
  }

  Future moveFolder(int toId, List<int> selectedIdx) async {
    List<int> selectedIds = new List();
    List<Coordinate> selectedProduct = new List();
    for (var idx in selectedIdx) {
      selectedIds.add(items[current_folder][idx].id);
      selectedProduct.add(items[current_folder][idx]);
    }
    try {
      var response = await _api.client.put(
          '${Api.endpoint}/v2/coordination/folder/move',
          data: jsonEncode({'folder_id': toId, 'coor_id': selectedIds}));
      items[toId] = [...items[toId], ...selectedProduct];
      for (var item in selectedProduct) {
        items[current_folder].remove(item);
      }
    } catch (e) {
      _api.errorCreate(Error());
    }
  }
}
