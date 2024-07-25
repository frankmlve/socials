import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socials/data/model/user.dart';
import 'package:socials/data/providers/current_user_provider.dart';
import 'package:socials/domain/repository/follow_repository.dart';
import 'package:socials/domain/repository/post_repository.dart';
import 'package:socials/presentation/model/post_card.dart';
import 'package:socials/presentation/widgets/post_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  User? _currentUser;
  final FollowRepository _followRepository = FollowRepository();
  final PostRepository _postRepository = PostRepository();
  List<PostCard> usersFollowedPost = [];

  @override
  void initState() {
    super.initState();
    fetchUsersFollowedPosts();
  }

  void fetchUsersFollowedPosts() async {
    List<User> posts = await _followRepository.fetchFollowingUsers();
    List<String> ids = [for (var user in posts) user.id];

    List<PostCard> fetchedPosts =
        await _postRepository.fetchUsersFollowedPosts(ids);
    setState(() {
      usersFollowedPost = fetchedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(currentUserNotifierProvider);
    setState(() {
      _currentUser = currentUser.value;
    });

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () {
              fetchUsersFollowedPosts();
              return Future.value();
            },
            child: ListView(
              children: [
                for (PostCard postCard in usersFollowedPost)
                  buildPostItem(postCard, fetchUsersFollowedPosts)
              ],
            )));
  }
}

buildPostItem(PostCard postCard, Function() fetchUsersFollowedPosts) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
    child: Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: PostWidget(
        post: postCard.post,
        user: postCard.user,
        comments: postCard.comments?.toList() ?? [],
        likes: postCard.likes,
        onCommentPost: fetchUsersFollowedPosts,
        onLikePostChange: fetchUsersFollowedPosts,
        onPostChange: () {},
        onPostDelete: () {},
      ),
    ),
  );
}
