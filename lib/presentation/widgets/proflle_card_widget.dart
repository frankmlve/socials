import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socials/domain/model/user.dart';
import 'package:socials/data/providers/current_user_provider.dart';
import 'package:socials/domain/repository/follow_repository.dart';
import 'package:socials/domain/repository/storage_repository.dart';
import 'package:socials/domain/repository/user_repository.dart';
import 'package:socials/presentation/manager/auth/auth.dart';
import 'package:socials/presentation/widgets/edit_profile_dialog.dart';

class ProfileCardWidget extends ConsumerStatefulWidget {
  final User user;
  final List<String> items;
  final bool userFollowed;
  final Function(User) onUpdateProfile;
  final Function(User) userHasChanged;
  final Function() onUserFollowed;
  const ProfileCardWidget(
      {super.key,
      required this.user,
      required this.items,
      required this.userFollowed,
      required this.onUpdateProfile,
      required this.onUserFollowed,
      required this.userHasChanged});

  @override
  ConsumerState<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends ConsumerState<ProfileCardWidget> {
  final FollowRepository _followRepository = FollowRepository();
  final UserRepository _userRepository = UserRepository();
  final StorageRepository _storageRepository = StorageRepository();
  XFile? _image;
  bool isLoading = false;

  Future<void> _handleFollow() async {
    if (widget.userFollowed) {
      await _followRepository.unfollowUser(widget.user.id);
    } else {
      await _followRepository.followUser(widget.user);
    }
    widget.onUserFollowed();
  }

  @override
  void initState() {
    super.initState();
  }

  Future _pickImageFromGallery() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 90);
    setState(() {
      _image = image;
    });
  }

  Future<void> _updateUserProfilePhoto() async {
    if (_image != null) {
      setState(() {
        isLoading = true;
      });
      var storagePath =
          'avatar/${Auth().currentUserId()}/${Random.secure().nextInt(1000)}';
      UploadTask task =
          _storageRepository.uploadImageToStorage(_image!.path, storagePath);
      task.snapshotEvents.listen((snapshot) {
        if (snapshot.state == TaskState.success) {
          snapshot.storage
              .ref()
              .child(storagePath)
              .getDownloadURL()
              .then((url) {
            widget.user.avatar = url;
            _userRepository.updateUser(widget.user).then((_) {
              widget.onUpdateProfile(widget.user);
              setState(() {
                isLoading = false;
              });
            });
          });
        }
      });
      User currentUser = widget.user;
      currentUser.avatar = _image!.path;
    }
  }

  TextButton buildShowMenuButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Edit Profile'),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => EditProfileDialog(
                                    user: widget.user,
                                    onSave: widget.onUpdateProfile,
                                  ));
                        },
                      ),
                      ListTile(
                        tileColor: Colors.red,
                        textColor: Colors.white,
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        title: Text('Logout'),
                        onTap: () {
                          Auth().signOut().then((_) => Navigator.pop(context));
                        },
                      )
                    ],
                  ));
        },
        child: Icon(Icons.menu));
  }

  GestureDetector buildProfilePicture(BuildContext context) {
    var avatar = widget.user.avatar == null
        ? AssetImage('assets/default-profile.png')
        : NetworkImage(widget.user.avatar ?? '');

    return GestureDetector(
      onTap: () {
        _pickImageFromGallery().then((image) {
          if (_image == null) return Container();
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('New Profile Picture'),
                  content: Card(
                    child: _image != null
                        ? Image.file(
                            File(_image!.path),
                            fit: BoxFit.fill,
                          )
                        : Container(),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => _updateUserProfilePhoto()
                            .then((_) => Navigator.pop(context)),
                        child: Text('Save')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                  ],
                );
              });
        });
      },
      child: CircleAvatar(
        radius: 40,
        backgroundImage: avatar as ImageProvider<Object>?,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.5,
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              children: [
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(mainAxisSize: MainAxisSize.max, children: [
                        buildProfilePicture(context),
                      ]),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.user.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(widget.user.description ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary))
                                ],
                              ),
                              widget.user.id == Auth().currentUserId()
                                  ? buildShowMenuButton(context)
                                  : Text('')
                            ]),
                      ),
                    ]),
                Row(
                  children: [
                    widget.user.id != Auth().currentUserId()
                        ? ElevatedButton(
                            onPressed: () => _handleFollow().then((_) {
                                  ref.refresh(
                                      currentUserNotifierProvider.future);
                                }),
                            child: widget.userFollowed
                                ? Text('Unfollow')
                                : Text('Follow'))
                        : Text(''),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Following',
                        style: TextStyle(fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16 ),),
                        Text(widget.user.followingCount.toString(),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 14),)
                      ],
                    )
                  ],
                )
              ],
            )));
  }
}
