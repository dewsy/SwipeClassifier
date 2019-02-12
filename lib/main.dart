import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';

import 'newDatasetPage.dart';
import 'dataset.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(primaryColor: Colors.lightGreen, accentColor: Colors.lightGreenAccent),
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
  Dataset newDataset = Dataset.empty();

  getNewDateset() async {
    Dataset temporaryDataset = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewDataset()));

    setState(() {
      newDataset = temporaryDataset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_pageTitle()}'),
      ),
      body: Center(child: Text('dataset')),
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

  String _pageTitle() {
    try {
      String _name = newDataset.name;
      return _name;
    } catch (e) {
      return 'No dataset selected';
    }
  }
}
