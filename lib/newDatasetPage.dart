import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import 'dataset.dart';
import 'folderPicker.dart';

class AddNewDataset extends StatefulWidget {
  @override
  _AddNewDatasetState createState() => _AddNewDatasetState();
}

class _AddNewDatasetState extends State<AddNewDataset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rNcontroller = TextEditingController();
  final TextEditingController _lNcontroller = TextEditingController();

  Dataset _newDataset = Dataset.empty();
  Directory _directory;

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
              children: <Widget>
              [_formPadding(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                    padding: EdgeInsets.only(right: 100
                    ),
                    child: Text(
                      'X Cancel',
                      style: TextStyle(color: Colors.redAccent),
                    ))),
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: RaisedButton(
              color: Colors.orange[200],
              textColor: Colors.white,
              onPressed: _submit,
              child: Text('Create Dataset'),
            ),),
          ]),],
            ),
          ),
        ));
  }

  Widget _formPadding() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: <Widget>[
          _arePicturesSelectedSwitcher(),
              _form()
        ],
      ),
    );
  }

  Widget _form() {
    if (_directory != null) {
    _nameController.text = p.basename(_directory.path);
    }
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
              onSaved: (input) {
                _newDataset.name = input;
                _newDataset.directory = _directory.path;
              },
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
              decoration: InputDecoration(hintText: "Left swipe name"),
              validator: (input) => input.isEmpty ? 'Required field' : null,
              onSaved: (input) => _newDataset.leftSwipeName = input,
              controller: _lNcontroller,
            ),
          ),
        ],
      ),
    );
  }

  _submit() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState.validate()) {
        if (_directory == null) {
          _showNoImageAlerBox();
        } else {
          _formKey.currentState.save();
          Navigator.pop(context, _newDataset);
        }
      }
    }
  }

  Widget _arePicturesSelectedSwitcher() {
    if (_directory == null) {
      return Container(
          margin: EdgeInsets.only(bottom: 30),
          child: IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 60,
              color: Colors.grey,
            ),
            tooltip: 'Import image from gallery',
            onPressed: getFolder,
          ));
    } else {
      return Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.only(bottom: 10),
          child: Center(
            child: Text(p.basename(_directory.path)),
          ));
    }
  }

  getFolder() async {
    Directory imagesDirectory = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => Picker()));
    setState(() {
      _directory = imagesDirectory;
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
