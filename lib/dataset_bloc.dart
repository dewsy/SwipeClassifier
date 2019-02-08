import 'dart:async';


class DatasetBloc {

  final StreamController<String> nameController = StreamController<String>();

  final StreamController<String> rNController = StreamController<String>();

  final StreamController<String> rTController = StreamController<String>();

  final StreamController<String> lNController = StreamController<String>();

  final StreamController<String> lTController = StreamController<String>();

  final StreamController<String> imagesController = StreamController<String>();

  @override
  dispose() {
    nameController.close();
  }

}
