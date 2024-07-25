import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final bool isFromNetwork;
  const CustomVideoPlayer({Key? key, required this.videoUrl, required this.isFromNetwork}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late Future<void> _initializeVideoPlayer;

  @override
  void initState() {
    super.initState();
    videoPlayerController = widget.isFromNetwork ? VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        : VideoPlayerController.file(File(widget.videoUrl));
    _initializeVideoPlayer = videoPlayerController.initialize();
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(1.0);
    videoPlayerController.play();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void togglePlay() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initializeVideoPlayer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: GestureDetector(
                  onTap: togglePlay,
                  child: VideoPlayer(videoPlayerController),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
