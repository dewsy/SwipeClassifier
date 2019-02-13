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
              body: Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              color: Colors.red,
              width: MediaQuery.of(context).size.width / 2,
            ),
            Container(
              color: Colors.blue,
              width: MediaQuery.of(context).size.width / 2,
            ),
          ],),
          _cardSwipes()
          ],),
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
    int currentIndex = 0;
    return
    Container(
      alignment: Alignment.center,
      child: Draggable(
        //TODO: Implement drag logic
        onDragCompleted: null,
        axis: Axis.horizontal,
          child:Image.file(
          newDataset.images[currentIndex],
          height: 500,
          width: 500,
          ),
        feedback: Image.file(
          newDataset.images[currentIndex],
          height: 500,
          width: 500,
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child:
        Image.file(
          newDataset.images[currentIndex + 1],
          height: 480,
          width: 480,
        )),
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
