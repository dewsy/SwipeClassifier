import 'package:flutter/material.dart';

class AddNewDataset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new dataset"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_size_select_actual),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
