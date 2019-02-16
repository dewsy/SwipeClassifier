import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'dataset.dart';

class AddNewDataset extends StatefulWidget {
  @override
  _AddNewDatasetState createState() => _AddNewDatasetState();
}

class _AddNewDatasetState extends State<AddNewDataset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rNcontroller = TextEditingController();
  final TextEditingController _rTcontroller = TextEditingController();
  final TextEditingController _lNcontroller = TextEditingController();
  final TextEditingController _lTcontroller = TextEditingController();

  Dataset _newDataset = Dataset.empty();
  List<File> _images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new dataset"),
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.lightGreenAccent,
            child: ListView(
              padding: const EdgeInsets.all(40.0),
              children: <Widget>[_arePicturesSelectedSwitcher(), _form()],
            ),
          ),
        ));
  }

  Widget _form() {
    return Form(
      key: _formKey,
      autovalidate: false,
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Dataset name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => _newDataset.name = input,
              controller: _nameController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Right swipe name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => _newDataset.rightSwipeName = input,
              controller: _rNcontroller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Right swipe tag"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => _newDataset.rightSwipeTag = input,
              controller: _rTcontroller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Left swipe name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => _newDataset.leftSwipeName = input,
              controller: _lNcontroller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Left swipe tag"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) {
                _newDataset.leftSwipeTag = input;
                _newDataset.images = _images;
              },
              controller: _lTcontroller,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                    padding: EdgeInsets.only(right: 150),
                    child: Text(
                      'X Cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ))),
            RaisedButton(
              color: Colors.orange[200],
              textColor: Colors.white,
              onPressed: _submit,
              child: Text('Create Dataset'),
            ),
          ]),
        ],
      ),
    );
  }

  _submit() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
        if (_images == null) {
          _showNoImageAlerBox();
        } else {
        _formKey.currentState.save();
        Navigator.pop(context, _newDataset);
        }
      }
    }
  }

  Widget _arePicturesSelectedSwitcher() {
    if (_images == null) {
      return Container(margin: EdgeInsets.only(bottom: 30) ,child: IconButton(
        icon: Icon(Icons.add_photo_alternate, size: 60, color: Colors.grey,),
        tooltip: 'Import images from gallery',
        onPressed: getImage,
      )); 
    } else {
      return Container(
          width: 50,
          height: 200,
          margin: EdgeInsets.only(bottom: 10),
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(_previewCount(), (index) {
              return Container(
                margin: EdgeInsets.all(5),
                child:Center(
                child: Image.file(
                  _images[index]
                ),
              ));
            }),
          ));
    }
  }

  int _previewCount() {
    return _images.length < 9 ? _images.length : 9;
  }

  getImage() async {
    var images = await MultiMediaPicker.pickImages(source: ImageSource.gallery);
    setState(() {
      _images = images;
    });
  }


  void _showNoImageAlerBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Ooopsie!"),
          content: new Text("You tried to create a Dataset without pictures"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
}
}
