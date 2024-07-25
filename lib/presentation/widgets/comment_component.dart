import 'package:flutter/material.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/widgets/avatar.dart';
import 'package:socials/data/model/comment.dart';

class CommentComponent extends StatelessWidget {
  final Comment comment;
  final Function(Comment comment) onDeleteComment;
  final TextStyle textStyle;

  CommentComponent(
      {required this.comment,
      required this.onDeleteComment,
      this.textStyle = const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Avatar(
                user: comment.user,
                size: 20,
                textStyle: textStyle,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                comment.comment,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ),
        Auth().currentUserId() == comment.user.id
            ? IconButton(
                onPressed: () => onDeleteComment(comment),
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 20,
                ))
            : Container()
      ]),
    );
  }
}
