import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socials/data/model/comment.dart';
import 'package:socials/data/model/like.dart';
import 'package:socials/data/model/post.dart';
import 'package:socials/data/model/user.dart';
import 'package:socials/domain/repository/post_repository.dart';
import 'package:socials/presentation/widgets/post_widget.dart';

class PostPage extends ConsumerStatefulWidget {
  final String postId;
  final User user;
  final Function() onPostDelete;

  PostPage(
      {required this.postId, required this.user, required this.onPostDelete});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final PostRepository _postRepository = PostRepository();
  Post? _post;
  List<Comment> _comments = [];
  List<Like>? _likes;

  @override
  void initState() {
    super.initState();
    fetchPost();
    fetchComments();
    fetchPostLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _post != null
          ? ListView(
          children: [PostWidget(
              post: _post!,
              user: widget.user,
              comments: _comments,
              likes: _likes,
              onCommentPost: fetchComments,
              onLikePostChange: fetchPostLikes,
              onPostChange: fetchPost,
              onPostDelete: widget.onPostDelete,
            )
          ]) : Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Circular progress indicator',
              ),
            ),
    );
  }

  void fetchPost() {
    _postRepository.fetchPost(widget.postId, widget.user.id).then((value) {
      setState(() {
        _post = value;
      });
    });
  }

  void fetchComments() {
    _postRepository
        .fetchPostComments(widget.postId, widget.user.id)
        .then((value) {
      setState(() {
        _comments = value;
      });
    });
  }

  void fetchPostLikes() {
    _postRepository.fetchPostLikes(widget.postId, widget.user.id).then((value) {
      setState(() {
        _likes = value;
      });
    });
  }
}
