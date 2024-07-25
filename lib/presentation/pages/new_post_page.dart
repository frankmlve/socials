import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_view_page.dart';

class NewPostPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const NewPostPage({super.key, required this.cameras});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late CameraController _cameraController;
  List<XFile> _image = [];
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _getAvailableCamera(widget.cameras.last);
  }

  void _getAvailableCamera(CameraDescription camera) {
    _cameraController = CameraController(camera, ResolutionPreset.max,
        enableAudio: true, imageFormatGroup: ImageFormatGroup.jpeg);
    _initializeControllerFuture = _cameraController.initialize();
  }

  Future _pickImageFromGallery() async {
    final image = await ImagePicker().pickMultipleMedia(imageQuality: 90);
    if (image.isNotEmpty) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection = _cameraController.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = widget.cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    _getAvailableCamera(newDescription);
  }
  Future<void> takePicture() async {
    await _initializeControllerFuture;
    final image = await _cameraController.takePicture();
    setState(() {
      _image = [image];
    });
  }
  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return Scaffold(
            body: ListView(
              children: [
                CameraPreview(_cameraController),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () {
                      try {
                        takePicture()
                        .then((_) {
                          if (_image.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ImageViewPage(imagePath: _image),
                              ),
                            );
                          }
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Icon(Icons.camera_alt),
                  ),
                  ElevatedButton(
                    onPressed: _toggleCameraLens,
                    child: const Icon(Icons.flip_camera_android),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _pickImageFromGallery().then((value) {
                          if (_image.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ImageViewPage(imagePath: _image),
                              ),
                            );
                          }
                        });
                      },
                      child: Icon(Icons.image)),
                ]),
              ],
            ),
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


}
