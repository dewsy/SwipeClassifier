import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:io';

import 'storageHandler.dart';
import 'dataset.dart';
import 'globals.dart';

class Swiper extends StatefulWidget {
  final BuildContext _context;
  final Dataset _currentDataset;
  final Function refresher;

  Swiper(this._context, this._currentDataset, this.refresher);

  @override
  _SwiperState createState() =>
      _SwiperState(_context, _currentDataset, refresher);
}

class _SwiperState extends State<Swiper> {
  BuildContext _context;
  Dataset _currentDataset;
  final Function refresher;

  _SwiperState(this._context, this._currentDataset, this.refresher);

  @override
  Widget build(BuildContext _context) {
    return SwipeDetector(
      onSwipeRight: () {
        _fileRenamer(_currentDataset.images[_currentDataset.counter],
            _currentDataset.rightSwipeTag);
        Globals().incrementCounter();
        print("Acceted RIGHT!");
        refresher();
      },
      onSwipeLeft: () {
        _fileRenamer(_currentDataset.images[_currentDataset.counter],
            _currentDataset.leftSwipeTag);
        Globals().incrementCounter();
        print("Accepted LEFT!");
        refresher();
      },
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  <Widget>[
        Center( child:Image.file(
        _currentDataset.images[_currentDataset.counter],
        height: 500,
        width: 500,
      )),
      Center(
        child: Text(
          "${(_currentDataset.counter + 1).toString() + '/' + _currentDataset.images.length.toString()}"),
      )
      ]));
  }

  _fileRenamer(File file, String tag) async {
    //TODO: Implement warning for too many dots
    List<String> splitname = file.path.split(".");
    await StorageHandler().getPermission().then(
        (onValue) => file.rename('${splitname[0] + tag + "." + splitname[1]}'));
  }
}
