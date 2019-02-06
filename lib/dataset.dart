import 'package:multi_image_picker/asset.dart';


class Dataset {
  String name;
  String rightSwipeName;
  String rightSwipeTag;
  String leftSwipeName;
  String leftSwipeTag;
  List<Asset> images;

Dataset(String name, String, rightSName, String rightSTag, String leftSName, String leftSTag, List<Asset> images) {
  this.name =name;
  this.rightSwipeName = rightSName;
  this.rightSwipeTag = rightSTag;
  this.leftSwipeName = leftSName;
  this.leftSwipeTag = leftSTag;
  this.images = images;
}

}