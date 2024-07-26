import '../../data/models/image_model.dart';

class ImageModel {
  final String dateOfCreate;
  final String imagePath;
  bool isLiked; 

  ImageModel({
    required this.dateOfCreate,
    required this.imagePath,
    this.isLiked = false, 
  });

  static final List<ImageModel> _images = imgList;

  static List<ImageModel> getAllImages() {
    return _images;
  }

  static void addImage(ImageModel image) {
    _images.add(image);
  }
}
