import 'package:flutter/material.dart';



class AddNewDataset extends StatefulWidget {
  @override
  _AddNewDatasetState createState() => _AddNewDatasetState();
}

class _AddNewDatasetState extends State<AddNewDataset> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String _dataSetName;

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
            children: <Widget>[_form()],
          ),
        ),
      ),
    );
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
              //TODO: Implement stream
              onSaved: (input) => null,
              controller: controller,
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
        _formKey.currentState.save();
      }
    }
  }
}
