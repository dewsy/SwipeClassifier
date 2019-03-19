import 'dart:convert';

class Dataset {
  String name;
  String rightSwipeName;
  String leftSwipeName;
  String directory;

  Dataset(this.name, this.rightSwipeName,
      this.leftSwipeName, this.directory);

  Dataset.empty() {
    this.name = '';
    this.rightSwipeName = '';
    this.leftSwipeName = '';
    this.directory = '';
  }

  Dataset.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    this.name = json['name'];
    this.rightSwipeName = json['rightSwipeName'];
    this.leftSwipeName = json['leftSwipeName'];
    this.directory = json['directory'];
    }
  }

