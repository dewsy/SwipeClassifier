import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'storageHandler.dart';

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  Directory storage;
  List<Widget> currentList = [];

  @override
  Widget build(BuildContext context) {
    listBuilder(storage);
    return Scaffold(
        appBar: AppBar(
          title: Text(p.basename(storage.path)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, storage);
              },
            )
          ],
        ),
        body: ListView(
          children: currentList,
        ));
  }

  listBuilder(Directory directory) async {
     if (storage = null) {
      storage = await getExternalStorageDirectory();
    }
    StorageHandler().getPermission();
    int counter = 0;
    List<Widget> finalList = [];
    List<FileSystemEntity> entities = directory.listSync();
    for (FileSystemEntity entity in entities) {
      if (entity is Directory) {
        finalList.add(GestureDetector(
            onTap: () {
              setState(() {
                storage = entity;
              });
            },
            child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Row(children: [
                  Icon(Icons.folder, color: Colors.green.shade400, size: 20),
                  Text(p.basename(entity.path)),
                ]))));
      } else if (!(counter > 3) && entity is File) {
        try {
          finalList.add(Image.file(entity));
          counter++;
        } catch (e) {
          print(e.toString());
        }
      }
    }

    setState(() {
      currentList = finalList;
    });
  }
}
