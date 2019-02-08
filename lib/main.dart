import 'package:flutter/material.dart';
import 'dart:io';

import 'package:multi_media_picker/multi_media_picker.dart';
import 'newDatasetPage.dart';
import 'bloc_provider.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: BlocProvider(
        bloc: null,
      child: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _images;

  Future getImage() async {
    var images = await MultiMediaPicker.pickImages(source: ImageSource.gallery);

    setState(() {
      _images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('//TODO Enter dataset name'),
      ),
      body: Center(
        child: _images == null
            ? Text('No image selected.')
            : Image.file(_images[0]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[200],
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewDataset()));
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.photo_library),
      ),
    );
  }
}
