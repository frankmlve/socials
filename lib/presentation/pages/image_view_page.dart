import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socials/data/providers/posts_provider.dart';
import 'package:socials/presentation/model/new_asset.dart';
import 'package:socials/presentation/widgets/image_slider.dart';


class ImageViewPage extends ConsumerStatefulWidget {
  final List<XFile> imagePath;
  const ImageViewPage({super.key, required this.imagePath});

  @override
  ConsumerState<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends ConsumerState<ImageViewPage> {
  bool isLoading = false;
  final TextEditingController captionController = TextEditingController();
  final storageRef = FirebaseStorage.instance.ref();


  @override
  Widget build(BuildContext context) {
    final currentUserPostsNotifier = ref.read(postsNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Captured Image'),
        ),
        body: !isLoading ? ListView(
            children: [
              ImageSlider(mediaList: widget.imagePath, isFromNetwork: false,),
                ListTile(
                  subtitle: TextField(
                      controller: captionController,
                      decoration: const InputDecoration(
                        labelText: 'Caption',
                        labelStyle: TextStyle(color: Colors.black),
                      ),),
                  trailing: TextButton(
                    onPressed: () => post(currentUserPostsNotifier, context),
                    child: Icon(Icons.send),
                  ),

                )
              ]) :
        Center(child: CircularProgressIndicator()),
    );
  }

  void post(PostsNotifier currentUserPostsNotifier, BuildContext context) {
    setState(() {
      isLoading = true;
    });

     List<NewAsset> imageUrls = widget.imagePath.map<NewAsset>((asset)
     {
       var type = asset.path.substring(asset.path.lastIndexOf('.') + 1);
       var path = asset.path;
       return NewAsset(path: path, type: type);
     }).toList();
    currentUserPostsNotifier.addPost(
        imageUrls, captionController.text)
        .then((value) => {
          setState(() {
            isLoading = false;
          }),
          Navigator.pop(context)
        });
  }
}
