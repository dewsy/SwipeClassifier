import 'package:multi_image_picker/asset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class Dataset {
  String name;
  String rightSwipeName;
  String rightSwipeTag;
  String leftSwipeName;
  String leftSwipeTag;
  List<Asset> images;

  Dataset(String name, String rightSName, String rightSTag, String leftSName,
      String leftSTag, List<Asset> images) {
    this.name = name;
    this.rightSwipeName = rightSName;
    this.rightSwipeTag = rightSTag;
    this.leftSwipeName = leftSName;
    this.leftSwipeTag = leftSTag;
    this.images = images;
  }

  Dataset.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    this.name = json['name'];
    this.rightSwipeName = json['rightSwipeName'];
    this.rightSwipeTag = json['rightSwipeTag'];
    this.leftSwipeName = json['leftSwipeName'];
    this.leftSwipeTag = json['leftSwipeTag'];
    for (String item in json['images']) {
      this.images.add(jsonDecode(item));
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
    for (Asset asset in this.images) {
      imagesInString.add(jsonifyOneAsset(asset));
    }
    return imagesInString;
  }

  String jsonifyOneAsset(Asset asset) {
    Map<String, dynamic> jsonMap = {
      'identifier': asset.identifier,
      'name': asset.name,
      'originalWidth': asset.originalWidth,
      'originalHeight': asset.originalHeight,
    };
    return jsonify(jsonMap);
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
