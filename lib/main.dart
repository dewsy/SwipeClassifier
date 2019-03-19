import 'package:flutter/material.dart';
import 'dart:io';

import 'newDatasetPage.dart';
import 'storageHandler.dart';
import 'dataset.dart';
import 'swiper.dart';
import 'globals.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(
        primaryColor: Colors.lightGreen, accentColor: Colors.lightGreenAccent),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  FileSystemEntity _currentImage;
  Dataset _currentDataset;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Globals().getDataset(),
        builder: (BuildContext context, AsyncSnapshot<Dataset> snapshot) {
          if (snapshot.hasData) {
            _currentDataset = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    "${snapshot.data.name == '' ? 'Swipe Classifier' : snapshot.data.name}"),
              ),
              body: _createMainScreen(snapshot),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orange[200],
                foregroundColor: Colors.white,
                onPressed: () {
                  _createNewDateset();
                },
                tooltip: 'Pick Image',
                child: Icon(
                  Icons.photo_library,
                ),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Please grant permission!'),
                ),
                body: Container());
          }
        });
  }

  _createNewDateset() async {
    Dataset temporaryDataset = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewDataset()));
    setState(() {
      if (temporaryDataset != null) {
        Globals().setDataset(temporaryDataset);
      }
    });
  }

  Widget _createMainScreen(AsyncSnapshot<Dataset> snapshot) {
    Dataset dataset = snapshot.data;
    return FutureBuilder(
        future: _getFirstImage(dataset.directory),
        builder: (BuildContext context,
            AsyncSnapshot<FileSystemEntity> imageSnapshot) {
          if (imageSnapshot.hasData) {
            if (imageSnapshot.data.path != "./init.rc") {
              return Swiper(dataset, _currentImage, refresher);
            } else if (imageSnapshot.data == null && dataset.name != '') {
              StorageHandler().deleteDataset(dataset.name);
              return _fullscreenMessage("All done, great job!");
            
          } else {
            return _fullscreenMessage("Add dataset with the button below");
          }
        }});
  }

  Widget _fullscreenMessage(String message) {
    return Center(
        child: Text(
      "$message",
      style: TextStyle(fontSize: 20),
    ));
  }

  Future<FileSystemEntity> _getFirstImage(String path) async {
    Stream<FileSystemEntity> entityStream =
        Directory(path).list(followLinks: false);
    FileSystemEntity temp = await entityStream.firstWhere((test) => test is File);
    _currentImage = temp;
    return temp;
  }

  refresher() {
    _getFirstImage(_currentDataset.directory);
    setState(() {
    });
  }
}
