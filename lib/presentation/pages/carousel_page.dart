import 'package:flutter/material.dart';
import 'carousel_image_view.dart';
import 'carousel_app_bar.dart';
import '../../domain/models/image_model.dart';

class CarouselPage extends StatefulWidget {
  final int initialIndex;
  final List<ImageModel> photos;
  final ValueChanged<List<ImageModel>> onLikeChanged;

  const CarouselPage({
    super.key,
    required this.initialIndex,
    required this.photos,
    required this.onLikeChanged,
  });

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  late PageController _pageController;
  int _currentImageIndex = 0;
  late List<ImageModel> _photos;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.8,
    );
    _currentImageIndex = widget.initialIndex;
    _photos = List.from(widget.photos);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onLikeChanged(_photos);
        return true;
      },
      child: Scaffold(
        appBar: CarouselAppBar(
          currentImageIndex: _currentImageIndex,
          photos: widget.photos,
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: widget.photos.length,
          itemBuilder: (context, index) {
            return CarouselImageView(
              photo: widget.photos[index],
              index: index,
              onLikeChanged: (isLiked) {
                setState(() {
                  widget.photos[index].isLiked = isLiked;
                });
              },
            );
          },
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          pageSnapping: true,
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
