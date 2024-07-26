import 'package:flutter/material.dart';
import '../../domain/models/image_model.dart';
import '../../uikit/theme/theme_data.dart';

class CarouselAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentImageIndex;
  final List<ImageModel> photos;

  const CarouselAppBar({
    super.key,
    required this.currentImageIndex,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        photos[currentImageIndex].dateOfCreate,
        style: AppTheme.headerStyle,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, photos);
        },
      ),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text.rich(
            TextSpan(
              style: AppTheme.headerStyle,
              children: <TextSpan>[
                TextSpan(
                  text: '${currentImageIndex + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '/${photos.length}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
