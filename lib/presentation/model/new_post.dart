import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socials/presentation/model/new_asset.dart';

class NewPost {
  String downloadURL;
  String? caption;
  FieldValue creation;
  List<NewAsset> assets;
  
  NewPost({required this.downloadURL, this.caption, required this.creation, required this.assets});

  Map<String, dynamic> toMap() {
    return {
      'downloadURL': downloadURL,
      'caption': caption,
      'creation': creation,
      'assets': [for (var asset in assets) asset.toMap()]
    };
  }
}