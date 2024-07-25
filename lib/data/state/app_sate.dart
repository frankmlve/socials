import 'package:flutter/material.dart';
import 'package:socials/data/model/post.dart';
import 'package:socials/domain/repository/post_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';

class AppState extends ChangeNotifier {

  PostRepository _postRepository = PostRepository();
  List<Post> posts = [];

  Future<void> fetchCurrentUserPosts() async {
    posts = await _postRepository.fetchUserPosts(Auth().currentUserId());
    notifyListeners();
  }



}