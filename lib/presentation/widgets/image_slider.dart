import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:socials/presentation/widgets/custom_video_player.dart';

class ImageSlider extends StatefulWidget {
  final List<XFile> mediaList;
  final bool isFromNetwork;
  const ImageSlider({
    Key? key,
    required this.mediaList,
    required this.isFromNetwork,
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.mediaList.length,
      itemBuilder: (context, index, realIndex) {
        final media = widget.mediaList[index];
        return buildItem(media);
      },
      options: CarouselOptions(
          height: MediaQuery.of(context).size.width,
          viewportFraction: 1.0,
          aspectRatio: 1 / 1,
          enableInfiniteScroll: false,
          enlargeCenterPage: false,
          onPageChanged: (index, reason) => setState(() {
                activeIndex = index;
              })),
    );
  }

  Widget buildItem(XFile media) {
    String mediaType = media.path.substring(media.path.lastIndexOf('.') + 1);

    if (mediaType == 'mp4') {
      return CustomVideoPlayer(
        videoUrl: media.path,
        isFromNetwork: widget.isFromNetwork,
      );
    } else {
      return Image.file(
        File(media.path),
        fit: BoxFit.fill,
      );
    }
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: widget.mediaList.length,
      );
}
