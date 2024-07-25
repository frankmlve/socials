
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socials/data/model/user.dart';

class NewComment {
  String comment;
  User user;
  NewComment({required this.comment, required this.user});

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'comment': comment,
      'createAt': FieldValue.serverTimestamp()
    };
  }
}