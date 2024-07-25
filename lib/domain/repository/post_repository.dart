import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socials/data/model/comment.dart';
import 'package:socials/data/model/like.dart';
import 'package:socials/data/model/post.dart';
import 'package:socials/data/model/user.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/model/new_comment.dart';
import 'package:socials/presentation/model/new_post.dart';
import 'package:socials/presentation/model/post_card.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final UserRepository _userRepository = UserRepository();

  Future<List<Post>> fetchUserPosts(String userId) async {
    var snapshot = await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .orderBy('creation', descending: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map<Post>((doc) => Post.fromMap(doc)).toList();
    } else {
      return [];
    }
  }

  Future<List<PostCard>> fetchUsersFollowedPosts(List<String> usersId) async {
    List<PostCard> postCards = [];
    for (var id in usersId) {
      var userSnapshot = await _userRepository.fetchUser(id);
      var snapshot = await _firebaseFirestore
          .collection('post')
          .doc(id)
          .collection('userPost')
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          List<Comment> comments = await fetchPostComments(doc.id, id);
          List<Like> likes = await fetchPostLikes(doc.id, id);
          PostCard postCard = PostCard(
            user: userSnapshot,
            post: Post.fromMap(doc),
            comments: comments,
            likes: likes
          );
          postCards.add(postCard);
        }
      }
    }
    return postCards;
  }

  Future<Post> fetchPost(String postId, String userId) async {
    var snapshot = await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(postId)
        .get();
    return Post.fromMap(snapshot);
  }

  Future<Post> makePost(NewPost post) async {
    var p = await _firebaseFirestore
        .collection('post')
        .doc(Auth().currentUserId())
        .collection('userPost')
        .add(post.toMap());
    return await fetchPost(p.id, Auth().currentUserId());
  }

  Future<List<Comment>> fetchPostComments(String postId, String userId) async {
    var snapshot = await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(postId)
        .collection('comments')
        .orderBy('createAt', descending: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map<Comment>((doc) => Comment.fromMap(doc)).toList();
    } else {
      return [];
    }
  }

  Future<List<Like>> fetchPostLikes(String postId, String userId) async {
    var snapshot = await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(postId)
        .collection('likes')
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map<Like>((doc) => Like.fromMap(doc)).toList();
    } else {
      return [];
    }
  }

  Future<void> commentPost(Post post, NewComment comment, String userId) async {
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .collection('comments')
        .add(comment.toMap());
  }

  Future<void> deleteComment(Post post, String userId, String commentId) async {
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  Future<void> likePost(Post post, String userId, User currentUser) async {
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .update({'likesCount': FieldValue.increment(1)});
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .collection('likes')
        .doc(Auth().currentUserId())
        .set(currentUser.toMap());
  }

  Future<void> unlikePost(Post post, String userId) async {
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .update({'likesCount': FieldValue.increment(-1)});
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .collection('likes')
        .doc(Auth().currentUserId())
        .delete();
  }

  Future<void> deletePost(Post post, String userId) async {
    fetchPostLikes(post.id, userId).then((like) async {
      var likeData = like;
      likeData.forEach((l) async {
        await _firebaseFirestore
            .collection('post')
            .doc(userId)
            .collection('userPost')
            .doc(post.id)
            .collection('likes')
            .doc(l.id)
            .delete();
      });
    });
    fetchPostComments(post.id, userId).then((comment) async {
      List<Comment> commentData = comment;
      commentData.forEach((c) async {
        await _firebaseFirestore
            .collection('post')
            .doc(userId)
            .collection('userPost')
            .doc(post.id)
            .collection('comments')
            .doc(c.id)
            .delete();
      });
    });
    await _firebaseFirestore
        .collection('post')
        .doc(userId)
        .collection('userPost')
        .doc(post.id)
        .delete();
  }

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
