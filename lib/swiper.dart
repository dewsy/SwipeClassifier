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
  Dataset _currentDataset;
  final Function refresher;

  _SwiperState(this._currentDataset, this.refresher);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getFirstImage(_currentDataset.directory),
        builder: (BuildContext context, AsyncSnapshot<FileSystemEntity> image) {
          if (image.hasData) {
            return SwipeDetector(
                onSwipeRight: () {
                  moveToSubdir(image.data, _currentDataset.rightSwipeName);
                },
                onSwipeLeft: () {
                  moveToSubdir(image.data, _currentDataset.leftSwipeName);
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Image.file(
                        image.data,
                        height: 500,
                        width: 500,
                      )),
                      Center(child: Text('${image.data.path}'))
                    ]));
          }
        });
  }

  moveToSubdir(File image, String subdirName) {
    String imageDir = p.dirname(image.path);
    String subdirPath = '${imageDir + "/" + subdirName}';
    FileUtils.mkdir([subdirPath]);
    StorageHandler().getPermission().then((onValue) {
      image.copySync('${subdirPath + "/" + p.basename(image.path)}');
      image.deleteSync();
      widget.refresher();
    });
  }

  Future<FileSystemEntity> _getFirstImage(String path) async {
    Stream<FileSystemEntity> entityStream =
        Directory(path).list(followLinks: false);
    return entityStream.firstWhere((test) => test is File);
  }
}
