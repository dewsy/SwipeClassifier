import 'package:flutter/material.dart';
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
    return Stack(
      children: <Widget>[
        Row(
          children: _dropTargets(),
        ),
        Container(
          child: _imageDragger(),
          margin: EdgeInsets.only(top: 70),
        )
      ],
    );
  }

  Widget _imageDragger() {
    return Container(
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Draggable(
          axis: Axis.horizontal,
          child: Image.file(
            _currentDataset.images[_currentDataset.counter],
            height: 500,
            width: 500,
          ),
          feedback: Image.file(
            _currentDataset.images[_currentDataset.counter],
            height: 500,
            width: 500,
          ),
          childWhenDragging: Container(
            height: 0,
            width: 0,
          )),
          Text(
            '${(_currentDataset.counter + 1).toString() + " / " + _currentDataset.images.length.toString()}',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          )
        ]));
  }

  _fileRenamer(File file, String tag) async {
    //TODO: Implement warning for too many dots
    List<String> splitname = file.path.split(".");
    await StorageHandler().getPermission().then(
        (onValue) => file.rename('${splitname[0] + tag + "." + splitname[1]}'));
  }

  List<Widget> _dropTargets() {
    return <Widget>[_leftDropTarget(), _rightDropTarget()];
  }

  Widget _leftDropTarget() {
    return Container(
      width: MediaQuery.of(_context).size.width / 2,
      child: DragTarget(builder: (context, candidate, rejected) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 10),
          alignment: Alignment.topLeft,
          child: Text(
            _currentDataset.leftSwipeName,
            style: TextStyle(fontSize: 30, color: Colors.grey),
          ),
        );
      }, onWillAccept: (data) {
        return true;
      }, onAccept: (data) {
        File _thisImage = _currentDataset.images[_currentDataset.counter];
        _fileRenamer(_thisImage, _currentDataset.leftSwipeTag);
        print('Accepted LEFT!');
        Globals().incrementCounter();
        widget.refresher();
      }),
    );
  }

  Widget _rightDropTarget() {
    return Container(
      width: MediaQuery.of(_context).size.width / 2,
      child: DragTarget(builder: (context, candidate, rejected) {
        return Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          alignment: Alignment.topRight,
          child: Text(
            _currentDataset.rightSwipeName,
            style: TextStyle(fontSize: 30, color: Colors.grey),
          ),
        );
      }, onWillAccept: (data) {
        return true;
      }, onAccept: (data) {
        File _thisImage = _currentDataset.images[_currentDataset.counter];
        _fileRenamer(_thisImage, _currentDataset.rightSwipeTag);
        print('Accepted RIGHT!');
        Globals().incrementCounter();
        widget.refresher();
      }),
    );
  }
}
