import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:socials/domain/model/assets.dart';
import 'package:socials/domain/model/post.dart';
import 'package:socials/presentation/widgets/custom_video_player.dart';

class CustomCarousel extends StatefulWidget {

  final Post post;
  final bool isFromNetwork;
  CustomCarousel({required this.post, required this.isFromNetwork});

  @override
  CustomCarouselState createState() => CustomCarouselState();
}
class CustomCarouselState extends State<CustomCarousel> {

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: widget.post.assets.length,
           itemBuilder: (context, index, realIndex) {
            final image = widget.post.assets[index];
            return buildImage(image, index);
           },
          options: CarouselOptions(
              height: MediaQuery.of(context).size.width,
              viewportFraction: 1.0,
              aspectRatio: 1/1,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) => setState(() {
                activeIndex = index;
              })),
        ),
        const SizedBox(height: 32,),
        buildIndicator()
      ],
    );
  }

  Widget buildImage(Assets asset, int index) => Container(
    margin: EdgeInsets.symmetric(horizontal: 0),
    color: Colors.grey,
    child: asset.type == 'jpg' ? Image.network(asset.path,
      fit: BoxFit.cover) :
    CustomVideoPlayer(
      videoUrl: asset.path,
      isFromNetwork: widget.isFromNetwork,
    ),
  );
  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: widget.post.assets.length,
   );
}