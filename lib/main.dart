import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Globals().getDataset(),
      builder: (BuildContext context, AsyncSnapshot<Dataset> snapshot) {
        if (snapshot.hasData) {
          return 
          Scaffold(
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
    if (dataset.images.isNotEmpty && dataset.images.length > dataset.counter) {
      return Swiper(context, dataset, refresher);
    } else if (dataset.images.length <= dataset.counter &&
        dataset.images.isNotEmpty) {
      StorageHandler().deleteDataset(dataset.name);
      return _fullscreenMessage("All done, great job!");
    } else {
      return _fullscreenMessage("Add dataset with the button below");
    }
  }

  Widget _fullscreenMessage(String message) {
    return Center(
        child: Text(
      "$message",
      style: TextStyle(fontSize: 20),
    ));
  }

  refresher() {
    setState(() {});
  }
}
