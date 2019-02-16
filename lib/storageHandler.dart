import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'dataset.dart';

class StorageHandler {


  Future<Dataset> loadDatasetFromStorage(String name) async {
   return await SharedPreferences.getInstance().then((onValue) {
    return Dataset.fromJson(onValue.getString(name));
    });
  }

  List<String> jsonifyImages(List<File> images) {
    List<String> _imagesInString = new List<String>();
    for (File _file in images) {
      _imagesInString.add(_file.path);
    }
    return _imagesInString;
  }

  Future<void> saveDataset(Dataset dataset) async {
    Map<String, dynamic> _jsonMap = {
      'name': dataset.name,
      'rightSwipeName': dataset.rightSwipeName,
      'rightSwipeTag': dataset.rightSwipeTag,
      'leftSwipeName': dataset.leftSwipeName,
      'leftSwipeTag': dataset.leftSwipeTag,
      'images': jsonifyImages(dataset.images)
    };
    await SharedPreferences.getInstance().then((onValue) {
    onValue.setString(dataset.name, jsonify(_jsonMap));
    onValue.setString("activeDataset", dataset.name);
    });
  }

  String jsonify(Map<String, dynamic> toJson) {
    return jsonEncode(toJson);
  }

  Future<Dataset> loadLatestDataset() async {
    return await SharedPreferences.getInstance().then((onValue) {
    String _latestName = onValue.getString('activeDataset');
    if (_latestName == null) {
      return Dataset.empty();
    } else {
      return loadDatasetFromStorage(_latestName);
    }
    });
  }

  Future<void> saveIndex(int index) async {
    await SharedPreferences.getInstance().then((i) {
      i.setInt('index', index);
    });
  }

  Future<int> loadIndex() async {
   return await SharedPreferences.getInstance().then((onData) {
     return _loadAsync(onData);});

  }

  int _loadAsync(SharedPreferences pref) {
   int index = pref.getInt('index');
       if (index == null) {
      return 0;
    } else {
      return index;
    }
  }

  Future<void> getPermission() async {
    await SimplePermissions.checkPermission(Permission.WriteExternalStorage)
        .then((onValue) async {
      if (!onValue) {
        await SimplePermissions.requestPermission(
                Permission.WriteExternalStorage)
            .then((onValue) {
          if (onValue == PermissionStatus.denied) {
            //TODO: handle rejection
          }
        });
      }
    });
  }
  
}
