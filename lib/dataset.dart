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

Dataset(String name, String, rightSName, String rightSTag, String leftSName, String leftSTag, List<Asset> images) {
  this.name =name;
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
  this.images = json['images'];
}

// TODO: move this to a class outside of Dataset
Future<Dataset> loadDatasetFromStorage(String name) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString(name);
  return Dataset.fromJson(jsonString);
}

Future<void> saveDataset() async {
   Map<String, dynamic> jsonMap =
  {
    'name' : this.name,
    'rightSwipeName' : this.rightSwipeName,
    'rightSwipeTag' : this.rightSwipeTag,
    'leftSwipeName' : this.leftSwipeName,
    'leftSwipeTag' : this.leftSwipeTag,
    'images' : this.images,
  };
  String jsonString = jsonEncode(jsonMap);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(this.name, jsonString);
}

}
