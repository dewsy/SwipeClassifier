import 'dataset.dart';
import 'storageHandler.dart';

class Globals {

  
  Dataset _dataset;

  static final Globals _singleton = new Globals._internal();

  factory Globals() {
    return _singleton;
  }

  Globals._internal();

  
  Future<Dataset> getDataset() async {
    if (_dataset == null) {
      _dataset = await StorageHandler().loadLatestDataset();
    }
    return _dataset;
  }

  int getCounter() {
    return _dataset.counter;
  }

  incrementCounter() {
    _dataset.counter++;
    setDataset(_dataset);
  }

  setDataset(Dataset dataset) {
    _dataset = dataset;
    StorageHandler().saveDataset(_dataset);
  }

}