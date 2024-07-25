import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final Icon? icon;
  final Function()? onTap;

  MenuItem({required this.title, this.icon, this.onTap});
}