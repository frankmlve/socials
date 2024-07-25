import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socials/presentation/manager/auth/auth_middleware.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  runApp(ProviderScope(
      child: MyApp(
    cameras: cameras,
  )));
}

class MyApp extends ConsumerWidget {
  final List<CameraDescription> cameras;

  MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return   MaterialApp(
        title: 'Socials',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        home: AuthMiddleware(
          cameras: cameras,
        ),
    );
  }
}
