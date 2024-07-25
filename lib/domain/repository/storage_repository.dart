import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageRepository {

  FirebaseStorage storage = FirebaseStorage.instance;


  UploadTask uploadImageToStorage(String filePath, String path) {
    File file = File(filePath);
    try {
      return storage.ref().child(path).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  UploadTask uploadFileToStorage(String filePath, Uint8List file) {
    try {
      return storage.ref().child(filePath).putData(file);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}