import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:io';
import 'package:file_utils/file_utils.dart';
import 'package:path/path.dart' as p;

import 'storageHandler.dart';
import 'dataset.dart';

class Swiper extends StatefulWidget {
  final Dataset _currentDataset;
  final Function refresher;

  Swiper(this._currentDataset, this.refresher);

  @override
  _SwiperState createState() => _SwiperState(_currentDataset, refresher);
}

class _SwiperState extends State<Swiper> {
  int counter;
  Dataset _currentDataset;
  final Function refresher;

  _SwiperState(this._currentDataset, this.refresher);

  @override
  Widget build(BuildContext context) {
    File _image = _getCurrentImage(_currentDataset.directory);
    return SwipeDetector(
        onSwipeRight: () {
          moveToSubdir(_image, _currentDataset.rightSwipeName);
        },
        onSwipeLeft: () {
          moveToSubdir(_image, _currentDataset.leftSwipeName);
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Image.file(
                _image,
                height: 500,
                width: 500,
              )),
              Center(child: Text('${counter.toString() +" images left"}'))
            ]));
  }

  moveToSubdir(File image, String subdirName) {
    String imageDir = p.dirname(image.path);
    String subdirPath = '${imageDir + "/" + subdirName}';
    FileUtils.mkdir([subdirPath]);
    StorageHandler().getPermission().then((onValue) {
      image.copySync('${"~" + subdirPath + "/" + p.basename(image.path)}');
      image.deleteSync();
      widget.refresher();
    });
  }

  File _getCurrentImage(String directory) {
    Directory dir = Directory(directory);
    List content = dir.listSync(recursive: false, followLinks: false);
    counter = content.length - 2;
    for (var piece in content) {
      if (piece is File) {
        return piece;
      }
    }
    return null;
  }
}
