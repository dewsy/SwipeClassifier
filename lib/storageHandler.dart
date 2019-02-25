import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'dart:convert';
import 'dart:async';

import 'dataset.dart';

class StorageHandler {


  Future<Dataset> loadDatasetFromStorage(String name) async {
    return await SharedPreferences.getInstance().then((onValue) {
      return Dataset.fromJson(onValue.getString(name));
    });
  }

  Future<void> saveDataset(Dataset dataset) async {
    Map<String, dynamic> _jsonMap = {
      'name': dataset.name,
      'rightSwipeName': dataset.rightSwipeName,
      'leftSwipeName': dataset.leftSwipeName,
      'directory': dataset.directory,
    };
    await SharedPreferences.getInstance().then((onValue) {
      onValue.setString(dataset.name, jsonify(_jsonMap));
      onValue.setString("activeDataset", dataset.name);
    });
  }

  String jsonify(Map<String, dynamic> toJson) {
    return jsonEncode(toJson);
  }

  Future<Dataset> loadLatestDataset() async {
    return await SharedPreferences.getInstance().then((onValue) {
      String _latestName = onValue.getString('activeDataset');
      if (_latestName == null) {
        return Dataset.empty();
      } else {
        return loadDatasetFromStorage(_latestName);
      }
    });
  }

  Future<void> getPermission() async {
    await SimplePermissions.checkPermission(Permission.WriteExternalStorage)
        .then((onValue) async {
      if (!onValue) {
        await SimplePermissions.requestPermission(
                Permission.WriteExternalStorage)
            .then((onValue) {
          if (onValue == PermissionStatus.denied) {
            //TODO: handle rejection
          }
        });
      }
    });
  }

  Future<void> deleteDataset(String name) async {
    await SharedPreferences.getInstance().then((onValue) {
      onValue.remove(name);
      onValue.remove('activeDataset');
    });
  }
}
