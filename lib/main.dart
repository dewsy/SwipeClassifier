import 'package:flutter/material.dart';
import 'dart:io';

import 'newDatasetPage.dart';
import 'storageHandler.dart';
import 'dataset.dart';

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
  Dataset _currentDataset;
  int _currentIndex;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getLatestDataset(),
        builder: (BuildContext context, AsyncSnapshot<Dataset> snapshot) {
          if (snapshot.hasData) {
            _currentDataset = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title:Text('${_pageTitle()}'),
              ),
              body: _checkForAvailableImages(),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.orange[200],
                foregroundColor: Colors.white,
                onPressed: () {
                  getNewDateset();
                },
                tooltip: 'Pick Image',
                child: Icon(Icons.photo_library,),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }


  getNewDateset() async {
    Dataset temporaryDataset = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewDataset()));

    setState(() {
      if (temporaryDataset != null) {
        _currentDataset = temporaryDataset;
        StorageHandler().saveDataset(_currentDataset);
      }});
  }


  Widget _checkForAvailableImages() {
    if (_currentDataset.images.isNotEmpty && _currentDataset.images.length > _currentIndex) {
      return _stack();
    }else if (_currentDataset.images.length  <= _currentIndex && _currentDataset.images.isNotEmpty) {
      _currentIndex = 0;
      StorageHandler().saveIndex(_currentIndex);
      return Center(
          child: Text(
        "All done! Good job!",
        style: TextStyle(fontSize: 20),
      ));
    } else {
      return Center(
          child: Text(
        "Add dataset with the button below",
        style: TextStyle(fontSize: 20),
      ));}
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
                    _currentDataset.leftSwipeName,
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                );
              }, onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                print('Accepted LEFT!');
                File thisImage = _currentDataset.images[_currentIndex];
                _fileRenamer(thisImage, _currentDataset.leftSwipeTag);
                ++_currentIndex;
                _reloadState();
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
                    _currentDataset.rightSwipeName,
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                );
              }, onWillAccept: (data) {
                return true;
              }, onAccept: (data) {
                print('Accepted RIGHT!');
                File thisImage = _currentDataset.images[_currentIndex];
                _fileRenamer(thisImage, _currentDataset.rightSwipeTag);
                ++_currentIndex;
                _reloadState();
              }),),],),
        Container( child:
        _cardSwipes(),
        margin: EdgeInsets.only(top: 70),
        )
      ],
    );}


  Widget _cardSwipes() {
    return 
    Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget> [
          Draggable(
          axis: Axis.horizontal,
          child: Image.file(
            _currentDataset.images[_currentIndex],
            height: 500,
            width: 500,
          ),
          feedback: Image.file(
            _currentDataset.images[_currentIndex],
            height: 500,
            width: 500,
          ),
          childWhenDragging: Container(
            height: 0,
            width: 0,
          )),
          Text('${(_currentIndex + 1).toString() + " / " + _currentDataset.images.length.toString()}', style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 20
          ),)
        ]));
  }

  

  Future<void> _reloadState() async{
    await StorageHandler().saveIndex(_currentIndex).then((i) {
      setState(() {
      });
    });
  }

  

  String _pageTitle() {
    String _name = _currentDataset.name;
    if (_name.length > 0) {
      return _name;
    } else {
      return 'Swipe Classifier';
    }
  }

  Future<Dataset> _getLatestDataset() async {
    _currentIndex = await StorageHandler().loadIndex();
    await StorageHandler().getPermission();
    return StorageHandler().loadLatestDataset();
  }

  _fileRenamer(File file, String tag) async {
    //TODO: Implement warning for too many dots
    List<String> splitname = file.path.split(".");
    await StorageHandler().getPermission().then(
        (onValue) => file.rename('${splitname[0] + tag + "." + splitname[1]}'));
  }
}
