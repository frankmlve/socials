import 'package:socials/data/model/user.dart';

class Like {
  String id;
  User user;
  Like({required this.id, required this.user});

  static fromMap(var like)  {
    var map = like.data() as Map<String, dynamic>;
    User user = User.fromPlainMap(map);
    return Like(
      id: like.id,
      user: User(
        id: user.id,
        name: user.name,
        avatar: user.avatar,
        email: user.email,
        description: user.description,
        followingCount: user.followingCount,
        followersCount: user.followersCount
      )
    );
  }
}