import 'dart:async';

import 'dataset.dart';

class DatasetStreamController {

  final StreamController<Dataset> _datasetStreamController = StreamController<Dataset>();

  Dataset _dataset = Dataset.empty();

  @override
  dispose() {
    _datasetStreamController.close();
  }

}