import 'package:socials/data/model/comment.dart';
import 'package:socials/data/model/like.dart';
import 'package:socials/data/model/post.dart';
import 'package:socials/data/model/user.dart';

class PostCard {
  final Post post;
  final User user;
  final List<Like>? likes;
  final List<Comment>? comments;

  PostCard({
    required this.post,
    required this.user,
    this.likes,
    this.comments,
  });

}
