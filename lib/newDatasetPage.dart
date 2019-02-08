import 'package:flutter/material.dart';

class AddNewDataset extends StatefulWidget {
  @override
  _AddNewDatasetState createState() => _AddNewDatasetState();
}


class _AddNewDatasetState extends State<AddNewDataset>{
  
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new dataset"),
      ),
      body: Container(
        margin: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Dateset name"
                ),
                //TODO: Implement stream
                onChanged: null,
                controller: controller,
              ),
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
