import 'dart:convert';
import 'dataset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';

class StorageHandler {
  Future<Dataset> loadDatasetFromStorage(String name) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(name);
    return Dataset.fromJson(jsonString);
  }

  List<String> jsonifyImages(List<File> images) {
    List<String> imagesInString = new List<String>();
    for (File file in images) {
      imagesInString.add(file.path);
    }
    return imagesInString;
  }

  Future<void> saveDataset(Dataset dataset) async {
    Map<String, dynamic> jsonMap = {
      'name': dataset.name,
      'rightSwipeName': dataset.rightSwipeName,
      'rightSwipeTag': dataset.rightSwipeTag,
      'leftSwipeName': dataset.leftSwipeName,
      'leftSwipeTag': dataset.leftSwipeTag,
      'images': jsonifyImages(dataset.images)
    };

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(dataset.name, jsonify(jsonMap));
    prefs.setString("activeDataset", dataset.name);
  }

  String jsonify(Map<String, dynamic> toJson) {
    return jsonEncode(toJson);
  }

  Future<Dataset> loadLatestDataset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String latestName = prefs.getString('activeDataset');
    if (latestName == null) {
      return Dataset.empty();
    } else {
      return loadDatasetFromStorage(latestName);
    }
  }

  Future<void> saveIndex(int index) async {
    await SharedPreferences.getInstance().then((i) {
      i.setInt('index', index);
    });
  }

  Future<int> loadIndex() async {
   return await SharedPreferences.getInstance().then((onData) {return _loadAsync(onData);});

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
