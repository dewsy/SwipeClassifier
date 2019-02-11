import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:multi_media_picker/multi_media_picker.dart';

import 'newDatasetPage.dart';
import 'dataset.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _images;
  Dataset newDataset = Dataset.empty();


  Future getImage() async {
    var images = await MultiMediaPicker.pickImages(source: ImageSource.gallery);

    setState(() {
      _images = images;
    });
  }
  
  getNewDateset() async {
    Dataset temporaryDataset = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => AddNewDataset()));

    setState(() {
      newDataset = temporaryDataset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('//TODO Enter dataset name'),
      ),
      body: Center(child: Text('${newDataset.name}')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[200],
        foregroundColor: Colors.white,
        onPressed: () {
          getNewDateset();
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.photo_library),
      ),
    );
  }
}
