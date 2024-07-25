import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socials/data/model/assets.dart';
import 'package:socials/data/model/comment.dart';
import 'package:socials/data/model/like.dart';
import 'package:socials/data/model/user.dart';

class Post  {
  String id;
  String? caption;
  User? user;
  List<Assets> assets;
  List<Comment>? comments = [];
  List<Like>? likes;
  int? likesCount;
  Timestamp creation;

  Post(
      {required this.id,
      this.caption,
      this.user,
      required this.assets,
      this.comments,
      this.likes,
      this.likesCount,
      required this.creation
      });

  static fromMap(var data) {
    var post = data.data() as Map<String, dynamic>;
    return Post(
        id: data.id,
        caption: post['caption'],
        user: null,
        assets: [for (var asset in post['assets']) Assets.fromMap(asset)],
        comments: [],
        likes: [],
        likesCount: post['likesCount'] ?? 0,
        creation: post['creation']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caption': caption,
      'downloadURL': assets,
      'user': user?.toMap(),
    };
  }
}
