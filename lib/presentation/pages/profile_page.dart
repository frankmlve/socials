import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/data/providers/current_user_provider.dart';
import 'package:socials/data/providers/posts_provider.dart';
import 'package:socials/domain/repository/follow_repository.dart';
import 'package:socials/domain/repository/post_repository.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/pages/post_page.dart';
import 'package:socials/presentation/widgets/proflle_card_widget.dart';

import '../../domain/model/post.dart';

class ProfilePage extends ConsumerStatefulWidget {
  final String? userId;
  ProfilePage({this.userId, super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  UserRepository userRepository = UserRepository();
  PostRepository postRepository = PostRepository();
  FollowRepository followRepository = FollowRepository();
  bool userFollowed = false;

  User _user = User(id: '', name: 'name', email: 'email');
  List<Post> _posts = [];

  void updateUserInfo(User user) {
    setUserState(user);
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchPosts();
  }

  void setUserState(User user) {
    setState(() {
      _user = user;
    });
  }

  void fetchUser() {
    if (widget.userId != null) {
      userRepository.fetchUser(widget.userId!).then((user) async {
        followRepository.isFollowing(user).then((isFollowed) {
          setState(() {
            _user = user;
            userFollowed = isFollowed;
          });
        });
      });
    }
  }

  void fetchPosts() async {
    if (widget.userId != null) {
      postRepository.fetchUserPosts(widget.userId!).then((value) {
        setState(() {
          for (var element in value) {
            _posts.add(element);
          }
        });
      });
    }
  }

  List<String> items = ['Edit Profile', 'Logout'];
  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsNotifierProvider);
    final currentUser = ref.watch(currentUserNotifierProvider);

    return Scaffold(
      appBar: widget.userId != null
          ? AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
      body: widget.userId == null
          ? currentUser.when(data: (user) {
              return buildProfileView(user, posts, context);
            }, error: (error, stackTrace) {
              return Text(error.toString());
            }, loading: () {
              return Center(child: CircularProgressIndicator());
            })
          : buildProfileViewAnonymousUser(_user, _posts, context),
    );
  }

  Column buildProfileView(
      User user, AsyncValue<List<Post>> posts, BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileCardWidget(
            user: user,
            items: items,
            userFollowed: userFollowed,
            onUpdateProfile: updateUserInfo,
            userHasChanged: setUserState,
            onUserFollowed: fetchUser,
          ),
          Expanded(
              child: widget.userId != null
                  ? buildPostView(_posts, context, user)
                  : posts.when(data: (post) {
                      return buildPostView(post, context, user);
                    }, error: (error, stackTrace) {
                      return Text(error.toString());
                    }, loading: () {
                      return Center(child: CircularProgressIndicator());
                    })),
        ]);
  }

  Column buildProfileViewAnonymousUser(
      User user, List<Post> posts, BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileCardWidget(
            user: user,
            items: items,
            userFollowed: userFollowed,
            onUpdateProfile: updateUserInfo,
            onUserFollowed: fetchUser,
            userHasChanged: setUserState,
          ),
          Expanded(child: buildPostView(_posts, context, user)),
        ]);
  }

  Widget buildPostView(List<Post> post, BuildContext context, User user) {
    print(post);
    return post.isEmpty
        ? Center(child: Text('There are no posts yet'))
        : GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: post.map((post) {
              return GestureDetector(
                  key: Key(post.id),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostPage(
                                  postId: post.id,
                                  user: user,
                                  onPostDelete: fetchPosts,
                                )));
                  },
                  child: post.assets.first.thumbnail != null
                      ? Image.network(post.assets.first.thumbnail!,
                  fit: BoxFit.fill,)
                      : Image.network(
                          post.assets[0].path,
                          fit: BoxFit.fill,
                        ));
            }).toList(),
          );
  }
}
