import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socials/presentation/pages/new_post_page.dart';
import 'package:socials/presentation/pages/profile_page.dart';
import 'package:socials/presentation/pages/home_page.dart';
import 'package:socials/presentation/pages/search_page.dart';

class MainNavigator extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainNavigator({super.key, required this.cameras});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  var selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    requestStoragePermission();
  }
  void requestStoragePermission() async {
    // Check if the platform is not web, as web has no permissions
    if (!kIsWeb) {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      // Request camera permission
      var cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        await Permission.camera.request();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: true,
          bottom: true,
          child: IndexedStack(
              index: selectedIndex,
              children: <Widget>[HomePage(),
              SearchPage(),
              NewPostPage(cameras: widget.cameras,),
              ProfilePage()]
          )
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
        ],
      ),
    );
  }
}


