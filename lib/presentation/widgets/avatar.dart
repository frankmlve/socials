import 'package:flutter/material.dart';
import 'package:socials/data/model/user.dart';

class Avatar extends StatelessWidget {
  final User user;
  final double size;
  final TextStyle textStyle;

  Avatar(
      {required this.user,
      this.size = 40,
      this.textStyle = const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)});

  @override
  Widget build(BuildContext context) {
    var avatar = user.avatar == null
        ? AssetImage('assets/default-profile.png')
        : NetworkImage(user.avatar ?? '');
    return Row(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: size,
              backgroundImage: avatar as ImageProvider<Object>?,
            ),
            SizedBox(
              width: 8,
            ),
            Text(user.name, style: textStyle)
          ],
        )
      ],
    );
  }
}
