import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Dataset {
  String name;
  String rightSwipeName;
  String rightSwipeTag;
  String leftSwipeName;
  String leftSwipeTag;
  List<File> images;

  Dataset.empty() {
    this.name = '';
    this.rightSwipeName = '';
    this.rightSwipeTag = '';
    this.leftSwipeName = '';
    this.leftSwipeTag = '';
    this.images = List<File>();
  }

  Dataset(this.name, this.rightSwipeName, this.rightSwipeTag, this.leftSwipeName, this.leftSwipeTag, this.images);
  

  Dataset.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    this.name = json['name'];
    this.rightSwipeName = json['rightSwipeName'];
    this.rightSwipeTag = json['rightSwipeTag'];
    this.leftSwipeName = json['leftSwipeName'];
    this.leftSwipeTag = json['leftSwipeTag'];
    for (String path in json['images']) {
      this.images.add(new File(path));
    }
  }

// TODO: move this to a class outside of Dataset
  Future<Dataset> loadDatasetFromStorage(String name) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString(name);
    return Dataset.fromJson(jsonString);
  }

  List<String> jsonifyImages() {
    List<String> imagesInString;
    for (File file in this.images) {
      imagesInString.add(file.path);
    }
    return imagesInString;
  }

  Future<void> saveDataset() async {
    Map<String, dynamic> jsonMap = {
      'name': this.name,
      'rightSwipeName': this.rightSwipeName,
      'rightSwipeTag': this.rightSwipeTag,
      'leftSwipeName': this.leftSwipeName,
      'leftSwipeTag': this.leftSwipeTag,
      'images': jsonifyImages()
    };

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(this.name, jsonify(jsonMap));
  }

  String jsonify(Map<String, dynamic> toJson) {
    return jsonEncode(toJson);
  }
}