import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socials/domain/model/post.dart';
import 'package:socials/domain/repository/post_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/model/new_asset.dart';
import 'package:socials/presentation/model/new_post.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'posts_provider.g.dart';

@riverpod
class PostsNotifier extends _$PostsNotifier {
  final PostRepository _postRepository = PostRepository();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<List<Post>> build() async {
    return _postRepository.fetchUserPosts(Auth().currentUserId());
  }

  Future<void> addPost(List<NewAsset> imagesPath, String caption) async {
    NewPost newPost = await uploadMultipleFiles(imagesPath, caption);
    Post post = await _postRepository.makePost(newPost);
    List<Post> postList = [...state.asData?.value ?? [], post];
    postList.sort((a, b) => b.creation.compareTo(a.creation));
    state = AsyncData(postList);
    ref.invalidateSelf();
    await future;
  }

  Future<NewPost> uploadMultipleFiles(
      List<NewAsset> imagesPath, String? caption) async {
    List<Future<NewAsset>> storageAssets = [];
    for (NewAsset imagePath in imagesPath) {
      var id = Random.secure().nextInt(1000);
      var storagePath = 'post/${Auth().currentUserId()}/$id';

      final task =
          _postRepository.uploadImageToStorage(imagePath.path, storagePath);
      storageAssets.add(task.snapshotEvents
          .where((event) => event.state == TaskState.success)
          .first
          .then((_) async {
        Uint8List? thumbnail;
        if (imagePath.type != 'jpg') {
          thumbnail = await VideoThumbnail.thumbnailData(
            video: imagePath.path,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 128,
            quality: 25,
          );
          if (thumbnail != null) {
            final url = await storageRef.child(storagePath).getDownloadURL();
            var thumbnailPath = '${storagePath}_thumb';
            final thumbnailTask =
                _postRepository.uploadFileToStorage(thumbnailPath, thumbnail);
            return thumbnailTask.snapshotEvents
                .where((event) => event.state == TaskState.success)
                .first
                .then((thumb) async {
              var thumbnailDownloadUrl =
                  await storageRef.child(thumbnailPath).getDownloadURL();
              return NewAsset(
                  path: url,
                  type: imagePath.type,
                  thumbnail: thumbnailDownloadUrl);
            });
          } else {
            var url = await storageRef.child(storagePath).getDownloadURL();
            return NewAsset(path: url, type: imagePath.type);
          }
        } else {
          var url = await storageRef.child(storagePath).getDownloadURL();
          return NewAsset(path: url, type: imagePath.type);
        }
      }));
    }
    return NewPost(
        caption: caption,
        downloadURL: '',
        creation: FieldValue.serverTimestamp(),
        assets: await Future.wait(storageAssets));
  }

  Future<void> deletePost(Post post) async {
    await _postRepository.deletePost(post, Auth().currentUserId());
    if (state.hasValue) {
      var newState = state.asData?.value
          .where((element) => element.id != post.id)
          .toList();
      state = AsyncData(newState ?? []);
    }
  }
}
