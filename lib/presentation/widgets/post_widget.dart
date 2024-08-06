import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socials/domain/model/comment.dart';
import 'package:socials/domain/model/like.dart';
import 'package:socials/domain/model/post.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/data/providers/current_user_provider.dart';
import 'package:socials/data/providers/posts_provider.dart';
import 'package:socials/domain/repository/post_repository.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/model/new_comment.dart';
import 'package:socials/presentation/model/menu_item.dart';
import 'package:socials/presentation/widgets/avatar.dart';
import 'package:socials/presentation/widgets/comment_component.dart';
import 'package:socials/presentation/widgets/custom_carousel.dart';

class PostWidget extends ConsumerStatefulWidget {
  final Post post;
  final User user;
  final List<Comment> comments;
  final List<Like>? likes;
  final Function() onCommentPost;
  final Function() onLikePostChange;
  final Function() onPostChange;
  final Function() onPostDelete;

  PostWidget({
    Key? key,
    required this.post,
    required this.user,
    required this.onCommentPost,
    required this.comments,
    this.likes,
    required this.onLikePostChange,
    required this.onPostChange,
    required this.onPostDelete,
  });

  @override
  ConsumerState<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  bool isComment = false;
  late FocusNode typeCommentNode;
  bool isLiked = false;
  List<Comment> comments = [];
  @override
  void initState() {
    super.initState();
    typeCommentNode = FocusNode();
    setState(() {
      comments = widget.comments;
    });
  }

  @override
  void dispose() {
    super.dispose();
    typeCommentNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserPosts = ref.read(postsNotifierProvider.notifier);
    final currentUser = ref.watch(currentUserNotifierProvider);

    final TextEditingController captionController = TextEditingController();
    final PostRepository postRepository = PostRepository();
    final UserRepository userRepository = UserRepository();

    List<MenuItem> menuList = [
      MenuItem(
          title: 'Delete Post',
          icon: Icon(Icons.delete),
          onTap: () => currentUserPosts
              .deletePost(widget.post)
              .then((value) => Navigator.pop(context))),
      MenuItem(
          title: 'Edit Post',
          icon: Icon(Icons.edit),
          onTap: () => print('edit post')),
    ];

    bool userLikePost() {
      if (widget.likes != null && widget.likes!.isNotEmpty) {
        setState(() {
          isLiked = widget.likes!
              .any((like) => like.user.id == Auth().currentUserId());
        });
        return isLiked;
      }
      return false;
    }

    Future<void> commentPost() async {
      if (captionController.text.isEmpty) {
        return;
      }
      currentUser.when(
          data: (user) async {
            NewComment comment = NewComment(
              user: user,
              comment: captionController.text,
            );
            await postRepository.commentPost(
                widget.post, comment, widget.user.id);
            captionController.clear();
            widget.onCommentPost();
            primaryFocus!.unfocus(disposition: UnfocusDisposition.scope);
          },
          loading: () {},
          error: (Object error, StackTrace stackTrace) {});
    }

    void likePost() async {
      User currentUser = await userRepository.fetchUser(Auth().currentUserId());
      await postRepository.likePost(widget.post, widget.user.id, currentUser);
      widget.onLikePostChange();
      widget.onPostChange();
    }

    void unlikePost() async {
      await postRepository.unlikePost(widget.post, widget.user.id);
      widget.onLikePostChange();
      widget.onPostChange();
    }

    void showCommentInput() {
      typeCommentNode.requestFocus();
      setState(() {
        isComment = !isComment;
      });
    }

    void deleteComment(Comment comment) async {
      await postRepository.deleteComment(
          widget.post, widget.user.id, comment.id);
      widget.onCommentPost();
    }

    ListTile buildNewCommentInput(
        TextEditingController captionController, Function() commentPost) {
      return ListTile(
        subtitle: TextField(
          autofocus: false,
          controller: captionController,
          style: TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Add a comment',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        trailing: TextButton(
          onPressed: () => commentPost(),
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
        ),
      );
    }

    listComments() {
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          isDismissible: true,
          builder: (context) => Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Divider(),
                  comments.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'No Comments posted yet',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  Comment comment = comments[index];
                                  return Column(
                                    children: [
                                      CommentComponent(
                                        comment: comment,
                                        onDeleteComment: deleteComment,
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        ),
                  buildNewCommentInput(captionController, commentPost),
                ],
              )));
    }

    Column buildActionsButtons(Function() unlikePost, Function() likePost,
        Function() userLikePost, Function() showCommentInput) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () {
                      isLiked ? unlikePost() : likePost();
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: userLikePost() ? Colors.red : Colors.grey,
                    )),
                Text(widget.post.likesCount.toString()),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      showCommentInput();
                      listComments();
                    }),
                Text(widget.comments.length.toString()),
              ],
            ),
          ),
          Row(mainAxisSize: MainAxisSize.max, children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(widget.post.caption ?? ''),
            )
          ])
        ],
      );
    }

    Padding buildPostCardHeader(List<MenuItem> menuList) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Avatar(
              user: widget.user,
              size: 25,
            ),
            Auth().currentUserId() == widget.user.id
                ? MenuAnchor(
                    builder: (BuildContext context, MenuController controller,
                        Widget? child) {
                      return IconButton(
                        onPressed: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'Show menu',
                      );
                    },
                    menuChildren: List<MenuItemButton>.generate(
                      2,
                      (int index) => MenuItemButton(
                        onPressed: menuList[index].onTap,
                        leadingIcon: menuList[index].icon,
                        child: Text(menuList[index].title),
                      ),
                    ))
                : Container()
          ]));
    }

    return Column(children: <Widget>[
      buildPostCardHeader(menuList),
      SizedBox(
        height: 15,
      ),
      CustomCarousel(post: widget.post, isFromNetwork: true),
      buildActionsButtons(unlikePost, likePost, userLikePost, showCommentInput),
    ]);
  }
}
