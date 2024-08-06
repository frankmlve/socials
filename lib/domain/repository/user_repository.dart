
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/presentation/model/new_user.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  Future<User> fetchUser(String userId) async {
    var snapshot = await _firebaseFirestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      return User.fromMap(snapshot);
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> createUser(NewUser user) async {
    await _firebaseFirestore.collection('users')
        .doc(user.id)
        .set(user.toMap());
  }
  Future<void> updateUser(User user) async {
    await _firebaseFirestore.collection('users').doc(user.id).update(user.toMap());
  }

  Future<List<User>> fetchAllUsers() {
    return _firebaseFirestore.collection('users').get().then((snapshot) {
      return snapshot.docs.map<User>((doc) => User.fromMap(doc)).toList();
    });
  }
}

