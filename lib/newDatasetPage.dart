import 'package:flutter/material.dart';
import 'package:multi_media_picker/multi_media_picker.dart';
import 'dart:io';

import 'dataset.dart';

class AddNewDataset extends StatefulWidget {
  @override
  _AddNewDatasetState createState() => _AddNewDatasetState();
}

class _AddNewDatasetState extends State<AddNewDataset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rNcontroller = TextEditingController();
  final TextEditingController rTcontroller = TextEditingController();
  final TextEditingController lNcontroller = TextEditingController();
  final TextEditingController lTcontroller = TextEditingController();

  Dataset newDataset = Dataset.empty();
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
              children: <Widget>[_buildChild(), _form()],
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
              decoration: InputDecoration(hintText: "Dateset name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => newDataset.name = input,
              controller: nameController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Right swipe name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => newDataset.rightSwipeName = input,
              controller: rNcontroller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Right swipe tag"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => newDataset.rightSwipeTag = input,
              controller: rTcontroller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Left swipe name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => newDataset.leftSwipeName = input,
              controller: lNcontroller,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Left swipe tag"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) {
                newDataset.leftSwipeTag = input;
                newDataset.images = _images;
              },
              controller: lTcontroller,
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
        if (_images.length != null) {
        _formKey.currentState.save();
        Navigator.pop(context, newDataset);
        } else {
          //TODO: alert user about no pictures selected
        }
      }
    }
  }

  Widget _buildChild() {
    if (_images != null) {
      return Container(
          width: 50,
          height: 200,
          margin: EdgeInsets.only(bottom: 10),
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(_previewCount(), (index) {
              return Container(
                margin: EdgeInsets.all(5),
                child:
              Center(
                child: Image.file(
                  _images[index]
                ),
              ));
            }),
          ));
    } else {
      return IconButton(
        icon: Icon(Icons.add_photo_alternate),
        tooltip: 'Import images from gallery',
        onPressed: getImage,
      );
    }
  }

  int _previewCount() {
    int count = _images.length < 9 ? _images.length : 9;
    return count; 
  }

  getImage() async {
    var images = await MultiMediaPicker.pickImages(source: ImageSource.gallery);

    setState(() {
      _images = images;
    });
  }
}
