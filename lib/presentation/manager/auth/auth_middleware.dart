import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:socials/presentation/manager/main_navigator.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/pages/auth/login_page.dart';

class AuthMiddleware extends StatefulWidget {
  final List<CameraDescription> cameras;
  const AuthMiddleware({Key? key, required this.cameras}) : super(key: key);
  @override
  State<AuthMiddleware> createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends State<AuthMiddleware> {  
  @override
  Widget build(BuildContext context) {
      return StreamBuilder(stream: Auth().authStateChanges,
       builder: (context, snapshot){
          if (snapshot.hasData) {
            return MainNavigator(cameras: widget.cameras);
          } else {
            return LoginPage();
          }
       });
  }
}