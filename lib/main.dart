import 'package:flutter/material.dart';

import 'newDatasetPage.dart';
import 'dataset.dart';
import 'storageHandler.dart';

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
              body: _cardSwipes(),
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

  Widget _cardSwipes() {
    return Center(
      child: Draggable(
        axis: Axis.horizontal,
        child: Image.file(
          newDataset.images[0],
          height: 400,
          width: 400,
        ),
        feedback: Image.file(
          newDataset.images[0],
          height: 400,
          width: 400,
        ),
        childWhenDragging: Image.file(
          newDataset.images[1],
          height: 400,
          width: 400,
        ),
      ),
    );
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
}
