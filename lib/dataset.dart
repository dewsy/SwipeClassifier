import 'dart:convert';
import 'dart:io';


class Dataset {
  String name;
  String rightSwipeName;
  String rightSwipeTag;
  String leftSwipeName;
  String leftSwipeTag;
  List<File> images;


  Dataset(this.name, this.rightSwipeName, this.rightSwipeTag, this.leftSwipeName, this.leftSwipeTag, this.images);


  Dataset.empty() {
    this.name = '';
    this.rightSwipeName = '';
    this.rightSwipeTag = '';
    this.leftSwipeName = '';
    this.leftSwipeTag = '';
    this.images = List<File>();
  }


  Dataset.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    this.name = json['name'];
    this.rightSwipeName = json['rightSwipeName'];
    this.rightSwipeTag = json['rightSwipeTag'];
    this.leftSwipeName = json['leftSwipeName'];
    this.leftSwipeTag = json['leftSwipeTag'];
    this.images = List<File>();
    for (String path in json['images']) {
      this.images.add(new File(path));
    }
  }  
}