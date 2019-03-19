import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:io';
import 'package:file_utils/file_utils.dart';
import 'package:path/path.dart' as p;

import 'storageHandler.dart';
import 'dataset.dart';

class Swiper extends StatelessWidget {
  final Dataset _currentDataset;
  final Function refresher;
  final File _image;

  Swiper(this._currentDataset, this._image, this.refresher);

  @override
  Widget build(BuildContext context) {
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
              Center(child: Text('${_image.path}'))
            ]));
  }

  moveToSubdir(File image, String subdirName) {
    String imageDir = p.dirname(image.path);
    String subdirPath = '${imageDir + "/" + subdirName}';
    StorageHandler().getPermission().then((onValue) {
      print("Got permission!");
      FileUtils.mkdir([subdirPath]);
      image.copySync('${subdirPath + "/" + p.basename(image.path)}');
      image.deleteSync();
      refresher();
    });
  }
}
