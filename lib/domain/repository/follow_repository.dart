import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/presentation/manager/auth/auth.dart';

class FollowRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> followUser(User user) async {
    await _firebaseFirestore.collection('users')
    .doc(Auth().currentUserId())
    .update({'followingCount': FieldValue.increment(1)});
    await _firebaseFirestore.collection('follow')
        .doc(Auth().currentUserId())
        .collection('userFollowing')
        .doc(user.id)
        .set({
          'id': user.id,
          'name': user.name,
          'avatar': user.avatar,
          'description': user.description
        });
    return true;
  }

  Future<bool> unfollowUser(String userId) async {
    await _firebaseFirestore.collection('users')
        .doc(Auth().currentUserId())
        .update({'followingCount': FieldValue.increment(-1)});
    await _firebaseFirestore.collection('follow')
    .doc(Auth().currentUserId())
    .collection('userFollowing').doc(userId).delete();
    return true;
  }

  Future<List<User>> fetchFollowingUsers() async {
    var snapshot = await _firebaseFirestore.collection('follow')
        .doc(Auth().currentUserId())
        .collection('userFollowing').get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map<User>((doc) => User.fromMap(doc)).toList();
    } else {
      return [];
    }
  }

  Future<bool> isFollowing(User user) async {
    List<User> followedUser = await fetchFollowingUsers();
    if (followedUser.isNotEmpty) {
      final ids = [for (var user in followedUser) user.id];
      return ids.contains(user.id);
    }
    return false;
  }
}