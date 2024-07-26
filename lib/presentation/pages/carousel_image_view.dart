import 'package:flutter/material.dart';
import 'dart:io';
import '../../domain/models/image_model.dart';

class CarouselImageView extends StatefulWidget {
  final ImageModel photo;
  final int index;
  final ValueChanged<bool> onLikeChanged;

  const CarouselImageView({
    super.key,
    required this.photo,
    required this.index,
    required this.onLikeChanged,
  });

  @override
  _CarouselImageViewState createState() => _CarouselImageViewState();
}

class _CarouselImageViewState extends State<CarouselImageView> {
  double _currentRotation = 0.0;
  double _currentScale = 1.0;
  Offset _currentOffset = Offset.zero;
  Offset _previousOffset = Offset.zero;
  Offset _scaleStartFocalPoint = Offset.zero;
  Size _imageSize = Size.zero;
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _screenSize = MediaQuery.of(context).size;
        _imageSize = Size(
          MediaQuery.of(context).size.width * 0.8,
          MediaQuery.of(context).size.height * 0.8,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageStack(),
            _buildLikeButton(),
          ],
        ),
      ),
    );
  }

  void _onScaleStart(ScaleStartDetails details) {
    _scaleStartFocalPoint = details.focalPoint;
    _previousOffset = _currentOffset;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentScale = details.scale;
      _currentRotation = details.rotation;

      
      final Offset normalizedOffset = (_scaleStartFocalPoint - _previousOffset) / _currentScale;
      
      
      _currentOffset = details.focalPoint - normalizedOffset;

      
      _currentOffset = _clampOffset(_currentOffset);
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    _previousOffset = _currentOffset;
  }

  Offset _clampOffset(Offset offset) {
    
    final double maxWidth = _imageSize.width * _currentScale - _screenSize.width;
    final double maxHeight = _imageSize.height * _currentScale - _screenSize.height;

    
    final double clampedX = offset.dx.clamp(-maxWidth / 2, maxWidth / 2);
    final double clampedY = offset.dy.clamp(-maxHeight / 2, maxHeight / 2);
    
    return Offset(clampedX, clampedY);
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        ClipRect(
          child: Transform.translate(
            offset: _currentOffset,
            child: Transform.scale(
              scale: _currentScale,
              child: Transform.rotate(
                angle: _currentRotation,
                child: Hero(
                  tag: 'photo_${widget.index}',
                  child: Container(
                    width: _imageSize.width,
                    height: _imageSize.height,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Image.file(File(widget.photo.imagePath)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLikeButton() {
    return IconButton(
      iconSize: 50.0,
      icon: Icon(
        widget.photo.isLiked ? Icons.favorite : Icons.favorite_border,
        color: widget.photo.isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        widget.onLikeChanged(!widget.photo.isLiked);
      },
    );
  }
}
