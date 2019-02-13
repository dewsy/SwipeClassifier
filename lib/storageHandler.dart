import 'dart:convert';
import 'dataset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

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
      return null;
    } else {
    return loadDatasetFromStorage(latestName);
    }
  }


}