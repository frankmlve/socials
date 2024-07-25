import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socials/data/model/user.dart';

class Comment {
  String id;
  User user;
  String comment;

  Comment({required this.id, required this.user, required this.comment});

  static fromMap(comment)  {
    User user = User.fromPlainMap(comment['user']);
    return Comment(
      id: comment.id,
      user: user,
      comment: comment['comment']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'comment': comment,
      'createAt': FieldValue.serverTimestamp()
    };
  }
}