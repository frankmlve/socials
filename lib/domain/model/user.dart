class User{
  String id;
  String name;
  String? avatar;
  String? description;
  String email;
  int followingCount;
  int followersCount;

  User({required this.id,
  required this.name,
  this.avatar, 
  this.description, 
  required this.email,
  this.followingCount = 0,
  this.followersCount = 0});

  static fromMap(var data) {
    var map = data.data() as Map<String, dynamic>;
    return User(
      id: data.id,
      name: map['name'],
      avatar: map['avatar'],
      description: map['description'],
      email: map['email']??'',
      followingCount: map['followingCount']??0,
      followersCount: map['followersCount']??0
    );
  }

  static fromPlainMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      description: map['description'],
      email: map['email']??'',
      followingCount: map['followingCount']??0,
      followersCount: map['followersCount']??0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'description': description,
    };
  }
}