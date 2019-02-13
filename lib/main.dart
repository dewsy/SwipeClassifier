import 'package:flutter/material.dart';

import 'newDatasetPage.dart';
import 'dataset.dart';
import 'storageHandler.dart';
import 'dart:io';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(
        primaryColor: Colors.lightGreen, accentColor: Colors.lightGreenAccent),
  ));
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
  Dataset newDataset;
  int currentIndex = 0;

  getNewDateset() async {
    Dataset temporaryDataset = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewDataset()));

    setState(() {
      if (temporaryDataset != null) {
        newDataset = temporaryDataset;
        StorageHandler().saveDataset(newDataset);
      }
    });
  }

  Widget _checkForAvailableImages() {
    if (newDataset.images.isNotEmpty) {
      return _stack();
    } else {
      return Center(child: Text("Add dataset with the button below", style: TextStyle(
        fontSize: 20
      ),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getLatestDataset(),
        builder: (BuildContext context, AsyncSnapshot<Dataset> snapshot) {
          if (snapshot.hasData) {
            newDataset = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('${_pageTitle()}'),
              ),
              body: _checkForAvailableImages(),
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
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _stack() {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
             // color: Colors.red,
              width: MediaQuery.of(context).size.width / 2,
              child: DragTarget(builder: (context, candidate, rejected) {
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    newDataset.leftSwipeName,
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                );
              }, onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                print('Accepted LEFT!');
                File thisImage = newDataset.images[currentIndex];
                _fileRenamer(thisImage, newDataset.leftSwipeTag);
                setState(() {
                  currentIndex++;
                });
              }),
            ),
            Container(
             // color: Colors.blue,
              width: MediaQuery.of(context).size.width / 2,
              child: DragTarget(builder: (context, candidate, rejected) {
                return Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  alignment: Alignment.topRight,
                  child: Text(
                    newDataset.rightSwipeName,
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                );
              }, onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                print('Accepted RIGHT!');
                File thisImage = newDataset.images[currentIndex];
                _fileRenamer(thisImage, newDataset.rightSwipeTag);
                setState(() {
                  currentIndex++;
                });
              }),
            ),
          ],
        ),
        _cardSwipes(),
      ],
    );
  }

  Widget _cardSwipes() {
    return Container(
        alignment: Alignment.center,
        child: Draggable(
            axis: Axis.horizontal,
            child: Image.file(
              newDataset.images[currentIndex],
              height: 500,
              width: 500,
            ),
            feedback: Image.file(
              newDataset.images[currentIndex],
              height: 500,
              width: 500,
            ),
            childWhenDragging: Container(
              height: 0,
              width: 0,
            )));
  }

  String _pageTitle() {
    try {
      String _name = newDataset.name;
      return _name;
    } catch (e) {
      return 'No dataset selected';
    }
  }

  Future<Dataset> _getLatestDataset() async {
    return StorageHandler().loadLatestDataset();
  }


_fileRenamer(File file, String tag) async {
  //TODO: Implement warning for too many dots
  List<String> splitname = file.path.split(".");
  bool result =
      await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
  if (!result) {
    PermissionStatus answer = await SimplePermissions.requestPermission(
        Permission.WriteExternalStorage);
    if (answer == PermissionStatus.denied) {
      //TODO: handle rejection
    } else {
      file.rename('${splitname[0] + tag + "." + splitname[1]}');
    }
  } else {
    file.rename('${splitname[0] + tag + "." + splitname[1]}');
  }
}
}
